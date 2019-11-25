class PeopleController < ApplicationController
  def show
    @person = Person.find!(request.path)
    setup_content_item_and_navigation_helpers(@person)
    render :show, locals: {
        person: @person,
    }
  end
end
