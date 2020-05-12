# frozen_string_literal: true

module SolidusSegment
  module Serializers
    class LineItemSerializer
      def initialize(line_item)
        @line_item = line_item
      end

      def to_h
        {
          id: line_item.variant.id,
          sku: line_item.variant.sku,
          name: line_item.product.name,
          variant: line_item.variant.options_text,
          price: line_item.price,
          quantity: line_item.quantity,
          currency: line_item.currency,
          value: line_item.total
        }.compact
      end

      private

      attr_reader :line_item
    end
  end
end
