# frozen_string_literal: true

module SolidusSegment
  module Serializers
    class ProductSerializer
      def initialize(line_item)
        @line_item = line_item
      end

      def to_h
        {
          id: line_item.variant.id,
          sku: line_item.variant.sku,
          name: line_item.product.name,
          price: line_item.price,
          quantity: line_item.quantity,
        }.compact
      end

      private

      attr_reader :line_item
    end
  end
end
