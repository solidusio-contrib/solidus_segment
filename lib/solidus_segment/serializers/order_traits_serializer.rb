# frozen_string_literal: true

module SolidusSegment
  module Serializers
    class OrderTraitsSerializer
      def initialize(order)
        @order = order
      end

      def to_h
        {
          email: order.email,
          phone: address&.phone,
          address: (AddressSerializer.new(address).to_h if address),
        }.compact
      end

      private

      attr_reader :order

      def address
        @address ||= order.bill_address
      end
    end
  end
end
