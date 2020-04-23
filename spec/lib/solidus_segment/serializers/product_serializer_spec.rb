# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Serializers::ProductSerializer do
  let(:product) { create(:product, name: "Product #1", sku: "SKU-1") }
  let(:line_item) { create(:line_item, product: product) }

  describe "#to_h" do
    it "returns an hash with the product fields to track" do
      serializer = described_class.new(line_item).to_h

      expect(serializer).to include(
        id: product.id,
        sku: "SKU-1",
        name: "Product #1",
        price: 10.0.to_d,
        quantity: 1,
      )
    end

    it "removes the element in case the value is empty" do
      line_item.product.name = nil
      serializer = described_class.new(line_item).to_h

      expect(serializer).not_to have_key(:name)
    end
  end
end
