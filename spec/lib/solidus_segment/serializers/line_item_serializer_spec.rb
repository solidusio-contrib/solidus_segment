# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Serializers::LineItemSerializer do
  let(:product) { create(:base_product, name: "Product #1") }
  let(:variant) { create(:variant, product: product) }
  let(:line_item) { create(:line_item, variant: variant, quantity: 5) }

  describe "#to_h" do
    it "returns an hash with the product fields to track" do
      serializer = described_class.new(line_item).to_h

      expect(serializer).to include(
        id: variant.id,
        sku: variant.sku,
        name: "Product #1",
        variant: "Size: S",
        price: 10.0.to_d,
        quantity: 5,
        currency: 'USD',
        value: 50.00.to_d
      )
    end

    it "removes the element in case the value is empty" do
      line_item.product.name = nil
      serializer = described_class.new(line_item).to_h

      expect(serializer).not_to have_key(:name)
    end
  end
end
