# frozen_string_literal: true

module SolidusSegment
  module Serializers
    class OrderSerializer
      def initialize(order)
        @order = order
      end

      def to_h
        {
          checkout_id: order.number,
          order_id: order.id,
          shipping: order.shipment_total,
          tax: order.additional_tax_total,
          discount: order.promo_total,
          total: order.total,
          revenue: revenue,
          currency: order.currency,
          coupon: order.coupon_code,
          products: products
        }.compact
      end

      private

      attr_reader :order

      def revenue
        order.total - order.shipment_total - order.additional_tax_total
      end

      def products
        order.line_items.map { |line_item| ProductSerializer.new(line_item).to_h }
      end
    end
  end
end
