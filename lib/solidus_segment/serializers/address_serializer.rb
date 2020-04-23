# frozen_string_literal: true

module SolidusSegment
  module Serializers
    class AddressSerializer
      def initialize(address)
        @address = address
      end

      def to_h
        {
          city: address.city,
          postal_code: address.zipcode,
          street: address.address1,
          country: address.country.name,
          state: address.state&.name,
        }.compact
      end

      private

      attr_reader :address
    end
  end
end
