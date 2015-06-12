describe('browse-columns.js', function() {

  beforeEach(function () {
    // The window size needs to be wider than 500 pixels, otherwise the
    // ajax-browsing will be disabled.
    setWindowSize(1024)
  })

  it("should cache objects", function() {
    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });

    expect(bc.sectionCache('prefix', 'object-name')).toBe(undefined);

    bc.sectionCache('prefix', 'object-name', 'cache-thing');

    expect(bc.sectionCache('prefix', 'object-name')).toBe('cache-thing');
  });

  it("should set page title", function() {
    GOVUK.BrowseColumns.prototype.setTitle('new-title');

    expect($('title').text()).toBe('new-title');
  });

  it("should get section data and cache it", function() {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['done', 'error', 'resolve']);
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj);
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj);

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });
    spyOn(bc, 'sectionCache');

    var responseObj = bc.getSectionData({ slug: 'section' });

    expect(jQuery.ajax).toHaveBeenCalledWith({
      url: '/browse/section.json'
    });
    expect(promiseObj.done).toHaveBeenCalled();
    promiseObj.done.calls.mostRecent().args[0]('response data')
    expect(bc.sectionCache).toHaveBeenCalled();
  });

  it("should use the section data from the cache if it has it", function() {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['done', 'resolve']);
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj);
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj);

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });
    bc.sectionCache('section', 'section', 'data');

    var responseObj = bc.getSectionData({ slug: 'section' });

    expect(jQuery.ajax.calls.any()).toBe(false);

    expect(promiseObj.resolve).toHaveBeenCalled();
    expect(promiseObj.resolve.calls.mostRecent().args[0]).toBe('data')
  });

  it("should get subsection data and cache it", function() {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['done', 'error', 'resolve']);
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj);
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj);

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });
    spyOn(bc, 'sectionCache');

    var responseObj = bc.getSectionData({ subsection: true, slug: 'section/subsection' });

    expect(jQuery.ajax).toHaveBeenCalledWith({
      url: '/browse/section/subsection.json'
    });
    expect(promiseObj.done).toHaveBeenCalled();
    promiseObj.done.calls.mostRecent().args[0]('response data')
    expect(bc.sectionCache).toHaveBeenCalled();
  });

  it("should use the subsection data from the cache if it has it", function() {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['done', 'resolve']);
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj);
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj);

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });
    bc.sectionCache('section', 'section/subsection', 'data');

    var responseObj = bc.getSectionData({ slug: 'section/subsection' });

    expect(jQuery.ajax.calls.any()).toBe(false);

    expect(promiseObj.resolve).toHaveBeenCalled();
    expect(promiseObj.resolve.calls.mostRecent().args[0]).toBe('data')
  });

  it("should parse a pathname", function() {
    var paths = [
      {
        path: '/browse',
        output: { section: '', path: '/browse', slug: '' }
      },
      {
        path: '/browse/tax',
        output: { section: 'tax', path: '/browse/tax', slug: 'tax' }
      },
      {
        path: '/browse/tax/money',
        output: { section: 'tax', subsection: 'money', path: '/browse/tax/money', slug: 'tax/money' }
      },
      {
        path: '/browse/tax-money/money',
        output: { section: 'tax-money', subsection: 'money', path: '/browse/tax-money/money', slug: 'tax-money/money' }
      }
    ];
    for(var i=0, pathLength=paths.length; i<pathLength; i++){
      expect(GOVUK.BrowseColumns.prototype.parsePathname(paths[i].path)).toEqual(paths[i].output);
    }
  });

  it("should update breadcrumbs", function(){
    var context;

    // section to section
    context = { $breadcrumbs: $('<ol><li>one</li></ol>') };
    GOVUK.BrowseColumns.prototype.updateBreadcrumbs.call(context, {});
    expect(context.$breadcrumbs.find('li').length).toEqual(1);

    // subsection to section
    context = { $breadcrumbs: $('<ol><li>one</li><li>two</li></ol>') };
    GOVUK.BrowseColumns.prototype.updateBreadcrumbs.call(context, {});
    expect(context.$breadcrumbs.find('li').length).toEqual(1);

    // subsection to subsection
    context = { $breadcrumbs: $('<ol><li>one</li><li>two</li></ol>'), $section: $('<div><h1>text</h1></div>') };
    GOVUK.BrowseColumns.prototype.updateBreadcrumbs.call(context, { subsection: "first/second", section: 'first' });
    expect(context.$breadcrumbs.find('li').length).toEqual(2);
    expect(context.$breadcrumbs.find('li a').attr('href')).toEqual('/browse/first');

    // section to subsection
    context = { $breadcrumbs: $('<ol><li>one</li></ol>'), $section: $('<div><h1>text</h1></div>') };
    GOVUK.BrowseColumns.prototype.updateBreadcrumbs.call(context, { subsection: "first/second", section: 'first' });
    expect(context.$breadcrumbs.find('li').length).toEqual(2);
    expect(context.$breadcrumbs.find('li a').attr('href')).toEqual('/browse/first');
  });

  // http://stackoverflow.com/questions/9821166/error-accessing-jquerywindow-height-in-jasmine-while-running-tests-in-maven
  function setWindowSize(size) {
    $.prototype.width = function() {
      var original = $.prototype.width;

      if (this[0] === window) {
        return size;
      } else {
        return original.apply(this, arguments);
      }
    }
  }
});
