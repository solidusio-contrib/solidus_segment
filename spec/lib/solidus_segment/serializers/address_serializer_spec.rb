# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Serializers::AddressSerializer do
  let(:address) { build_stubbed(:address, zipcode: '12345') }

  describe "#to_h" do
    it "returns an hash with address keys needed by Segment" do
      serializer = described_class.new(address).to_h

      expect(serializer).to include(
        city: 'Herndon',
        postal_code: '12345',
        street: '10 Lovely Street',
        country: 'United States',
        state: 'Alabama',
      )
    end

    it "removes the element in case the value is empty" do
      address.state = nil
      serializer = described_class.new(address).to_h

      expect(serializer).not_to have_key(:state)
    end
  end
end
