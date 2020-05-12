# frozen_string_literal: true

module SolidusSegment
  module Serializers
    class ProductSerializer
      def initialize(product)
        @product = product
      end

      def to_h
        return VariantSerializer.new(product).to_h if product.is_a? Spree::Variant
        return LineItemSerializer.new(product).to_h if product.is_a? Spree::LineItem

        fail ArgumentError, 'Passed product should be a variant or a line item!'
      end

      private

      attr_reader :product
    end
  end
end
