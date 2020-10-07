describe LocalRestriction do
  let(:restriction) { described_class.new("E08000001") }

  it "returns the area name" do
    LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
      assert_equal "Tatooine", restriction.area_name
    end
  end

  it "returns the alert level" do
    LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
      assert_equal 4, restriction.alert_level
    end
  end

  it "returns the guidance" do
    LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
      guidance = restriction.guidance
      assert_equal "These are not the restrictions you are looking for", guidance["label"]
      assert_equal "guidance/tatooine-local-restrictions", guidance["link"]
    end
  end

  it "returns the extra restrictions" do
    LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
      assert_nil restriction.extra_restrictions
    end
  end

  it "returns nil values if the gss code doesn't exist" do
    LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
      restriction = described_class.new("fake code")
      assert_nil restriction.area_name
      assert_nil restriction.guidance
    end
  end

  describe "#start_date" do
    it "returns the start date" do
      LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
        assert_equal "01 October 2020".to_date, restriction.start_date
      end
    end

    it "allows the start date to be nil" do
      LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
        restriction = described_class.new("E08000002")
        assert_nil restriction.start_date
      end
    end
  end

  describe "#end_date" do
    it "returns the end date" do
      LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
        assert_equal "02 October 2020".to_date, restriction.end_date
      end
    end

    it "allows the end date to be nil" do
      LocalRestriction.stub_const(:FILE_PATH, "test/fixtures/local-restrictions.yaml") do
        restriction = described_class.new("E08000002")
        assert_nil restriction.end_date
      end
    end
  end
end
