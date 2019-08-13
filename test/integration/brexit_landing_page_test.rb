require 'integration_test_helper'
require_relative '../support/brexit_landing_page_steps'

class BrexitLandingPageTest < ActionDispatch::IntegrationTest
  include BrexitLandingPageSteps

  it "renders the brexit page" do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    then_i_can_see_the_title_section
    then_i_can_see_the_header_section
    then_i_can_see_the_get_ready_section
    then_i_can_see_the_share_links_section
    then_i_can_see_the_buckets_section
    and_i_can_see_the_explore_topics_section
  end

  it "renders the brexit page countdown" do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page_at_this_time(Date.parse("2019-08-12"))
    then_i_can_see_the_countdown_to(80)
    when_i_visit_the_brexit_landing_page_at_this_time(Date.parse("2019-10-30 23:00:00"))
    then_i_can_see_the_countdown_to(1)
    when_i_visit_the_brexit_landing_page_at_this_time(Date.parse("2019-10-31 01:00:00"))
    then_i_can_see_the_countdown_to(0)
    when_i_visit_the_brexit_landing_page_at_this_time(Date.parse("2019-10-31 23:59:00"))
    then_i_can_see_the_countdown_to(0)
    when_i_visit_the_brexit_landing_page_at_this_time(Date.parse("2019-11-1 00:00:00"))
    then_i_cannot_see_the_countdown
  end

  it "has tracking on all links" do
    given_there_is_a_brexit_taxon
    when_i_visit_the_brexit_landing_page
    then_all_links_have_tracking_data
  end
end
