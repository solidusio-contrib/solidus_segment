# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Serializers::OrderTraitsSerializer do
  let(:order) { build_stubbed(:order, email: "admin@example.com") }

  describe "#to_h" do
    it "returns an hash with reserved traits keys" do
      serializer = described_class.new(order).to_h

      expect(serializer).to include(
        address: instance_of(Hash),
        email: "admin@example.com",
        phone: "555-555-0199",
      )
    end

    it "removes the element in case the value is empty" do
      order.bill_address = nil
      serializer = described_class.new(order).to_h

      expect(serializer).not_to have_key(:address)
    end
  end
end
