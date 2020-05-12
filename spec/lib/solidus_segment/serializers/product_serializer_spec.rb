# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Serializers::ProductSerializer do
  let(:product) { create(:base_product, name: "Product #1") }
  let(:variant) { create(:variant, product: product) }
  let(:line_item) { create(:line_item, variant: variant, quantity: 5) }

  describe "#to_h" do
    context "with a variant" do
      let(:variant_serializer) { instance_spy(SolidusSegment::Serializers::VariantSerializer) }

      before do
        allow(SolidusSegment::Serializers::VariantSerializer)
          .to receive(:new)
          .with(variant)
          .and_return(variant_serializer)

        allow(variant_serializer).to receive(:to_h)
      end

      it "calls the variant serializer" do
        described_class.new(variant).to_h

        expect(variant_serializer).to have_received(:to_h)
      end
    end

    context "with a line item" do
      let(:line_item_serializer) { instance_spy(SolidusSegment::Serializers::LineItemSerializer) }

      before do
        allow(SolidusSegment::Serializers::LineItemSerializer)
          .to receive(:new)
          .with(line_item)
          .and_return(line_item_serializer)

        allow(line_item_serializer).to receive(:to_h)
      end

      it "calls the line item serializer" do
        described_class.new(line_item).to_h

        expect(line_item_serializer).to have_received(:to_h)
      end
    end

    context "with a wrong object" do
      it "raises argument error" do
        expect {
          described_class.new(Object.new).to_h
        }.to raise_error(ArgumentError)
      end
    end
  end
end
