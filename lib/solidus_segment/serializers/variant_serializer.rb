# frozen_string_literal: true

module SolidusSegment
  module Serializers
    class VariantSerializer
      def initialize(variant)
        @variant = variant
      end

      def to_h
        {
          id: variant.id,
          sku: variant.sku,
          name: variant.product.name,
          variant: variant.options_text,
          price: variant.price,
          currency: variant.default_price.currency
        }.compact
      end

      private

      attr_reader :variant
    end
  end
end
