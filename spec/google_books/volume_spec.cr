require "../spec_helper"

describe GoogleBooks::Volume do
  describe ".list" do
    it "returns a list result of volumes for a given query" do
      VCR.use_cassette("volume_list") do
        result = GoogleBooks::Volume.list("intitle:Mockingbird")

        result.kind.should eq "books#volumes"
        result.items.size.should be > 0
        result.total_items.should be >= result.items.size
      end
    end
  end

  describe ".get" do
    it "returns a volume" do
      VCR.use_cassette("volume_get") do
        result = GoogleBooks::Volume.get("P6bzCgUuVroC")

        fail("expected to find a volume") if result.nil?
        result.kind.should eq "books#volume"
        result.id.should eq "P6bzCgUuVroC"
      end
    end

    it "returns nothing if volume not found" do
      VCR.use_cassette("volume_get_not_found") do
        result = GoogleBooks::Volume.get("P6bzCgUuVrhD")

        result.should be_nil
      end
    end

    it "returns nothing if 503 response due to strictness in id format" do
      VCR.use_cassette("volume_get_503") do
        result = GoogleBooks::Volume.get("NOT_A_VALID_ID")

        result.should be_nil
      end
    end
  end
end
