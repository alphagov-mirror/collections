require "test_helper"

describe TransitionLandingPageController do
  include TaxonHelpers
  include GovukAbTesting::MinitestHelpers

  describe "GET show" do
    before do
      brexit_taxon = taxon
      brexit_taxon["base_path"] = "/transition"
      stub_content_store_has_item(brexit_taxon["base_path"], brexit_taxon)
      stub_content_store_has_item(brexit_taxon["base_path"] + ".cy", brexit_taxon)
    end

    %w[cy en].each do |locale|
      params = locale == "en" ? {} : { locale: locale }

      it "renders the page for the #{locale} locale" do
        get :show, params: params
        assert_response :success
      end
    end

    context "accounts header AB test setup" do
      subject { get :show }

      %w[LoggedIn LoggedOut].each do |variant|
        it "Variant #{variant} disables the search field" do
          with_variant AccountExperiment: variant do
            expect(response.headers["X-Slimmer-Remove-Search"]).to eq("true")
          end
        end
      end

      it "Variant LoggedIn requests the signed-in header" do
        with_variant AccountExperiment: :LoggedIn do
          expect(response.headers["X-Slimmer-Show-Accounts"]).to eq("signed-in")
        end
      end

      it "Variant Loggedout requests the signed-out header" do
        with_variant AccountExperiment: :LoggedIn do
          expect(response.headers["X-Slimmer-Show-Accounts"]).to eq("signed-out")
        end
      end
    end
  end
end
