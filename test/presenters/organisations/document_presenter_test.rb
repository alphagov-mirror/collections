require "test_helper"

describe Organisations::DocumentPresenter do
  describe "#present" do
    it "transforms" do
      expected = {
        link: {
          text: "Quiddich World Cup 2022 begins",
          path: "/government/news/its-coming-home",
          locale: "en",
        },
        metadata: {
          public_updated_at: Date.parse("2022-11-21T12:00:00.000+01:00"),
          document_type: "News story",
          locale: {
            public_updated_at: false,
            document_type: false,
          },
        },
      }

      assert_equal expected, presenter.present
    end
  end

  context "content_store_document_type has an acronym" do
    it "transforms the acronym in the doc type" do
      expected = presenter({ "content_store_document_type" => "Aaib_report" })

      assert_equal expected.present[:metadata][:document_type], "Air Accidents Investigation Branch report"
    end
  end

  context "metadata is excluded" do
    it "excludes the metadata" do
      expected = {
        link: {
          text: "Quiddich World Cup 2022 begins",
          path: "/government/news/its-coming-home",
          locale: "en",
        },
      }

      assert_equal expected, presenter(include_metadata: false).present
    end
  end

  def presenter(options = {}, include_metadata: true)
    params = {
      "title" => "Quiddich World Cup 2022 begins",
      "link" => "/government/news/its-coming-home",
      "content_store_document_type" => "news_story",
      "public_timestamp" => "2022-11-21T12:00:00.000+01:00",
    }.merge(options)

    described_class.new(params, include_metadata: include_metadata)
  end
end
