// Copied from whitehall to allow the feed panel to display when clicking on the
// "feed" link generated for whitehall based email and feed subscriptions

(function () {
  'use strict'
  window.GOVUK = window.GOVUK || {}

  window.GOVUK.feeds = {
    init: function () {
      $('.js-feed').on('click', window.GOVUK.feeds.toggle)
    },
    toggle: function (e) {
      e.preventDefault()
      var panel = $(e.target).siblings('.js-feed-panel')
      panel.toggle()
      panel.find('input').select()
    }
  }

  $(function () { GOVUK.feeds.init() })
}())
