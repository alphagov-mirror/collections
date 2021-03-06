require "integration_spec_helper"

RSpec.feature "Services and information browsing" do
  include SearchApiHelpers
  include ServicesAndInformationHelpers

  before do
    stub_services_and_information_links("hm-revenue-customs")
    stub_services_and_information_content_item
  end

  scenario "is possible to visit the services and information index page" do
    visit "/government/organisations/hm-revenue-customs/services-information"

    expect(page).to have_title("Services and information - HM Revenue & Customs - GOV.UK")

    within "header.page-header" do
      expect(page).to have_content("Services and information")
    end

    within ".govuk-grid-row:nth-child(1) h2" do
      expect(page).to have_content("Environmental permits")
    end

    within ".govuk-grid-row:nth-child(2) h2" do
      expect(page).to have_content("Waste")
    end

    expect(page).to have_selector(".gem-c-breadcrumbs")
  end

  scenario "includes tracking attributes on all links" do
    visit "/government/organisations/hm-revenue-customs/services-information"

    expect(page).to have_selector('.browse-container[data-module="gem-track-click"]')

    within ".govuk-grid-row:first-child .app-c-topic-list" do
      content_item_link = page.first("li a")

      expect(content_item_link["data-track-category"]).to eq("navServicesInformationLinkClicked")

      expect(content_item_link["data-track-action"]).to eq("1.1")

      expect(content_item_link["data-track-label"]).to eq(content_item_link[:href])

      expect(content_item_link["data-track-options"]).to be_present

      data_options = JSON.parse(content_item_link["data-track-options"])
      expect(data_options["dimension28"]).to eq(page.all("li a").count.to_s)

      expect(data_options["dimension29"]).to eq(content_item_link.text)
    end

    within ".govuk-grid-row:nth-child(2) .app-c-topic-list" do
      content_item_link = page.first("li a")

      expect(content_item_link["data-track-category"]).to eq("navServicesInformationLinkClicked")

      expect(content_item_link["data-track-action"]).to eq("2.1")

      expect(content_item_link["data-track-label"]).to eq(content_item_link[:href])

      expect(content_item_link["data-track-options"]).to be_present

      data_options = JSON.parse(content_item_link["data-track-options"])
      expect(data_options["dimension28"]).to eq(page.all("li a").count.to_s)

      expect(data_options["dimension29"]).to eq(content_item_link.text)
    end
  end
end
