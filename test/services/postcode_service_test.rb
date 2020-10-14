require "test_helper"

describe PostcodeService do
  describe "#valid?" do
    it "returns true if postcode is valid" do
      postcode = "E1 8QS"
      assert(described_class.new(postcode).valid?)
    end

    it "returns false if the postcode is not valid" do
      postcode = "invalid postcode"
      assert_not(described_class.new(postcode).valid?)
    end
  end
end
