# frozen_string_literal: true

module SolidusSegment
  module Serializers
    class TraitsSerializer
      def initialize(user)
        @user = user
      end

      def to_h
        {
          id: user.id,
          email: user.email,
          username: user.login,
          phone: address&.phone,
          address: (AddressSerializer.new(address).to_h if address),
          created_at: user.created_at,
        }.compact
      end

      private

      attr_reader :user

      def address
        @address ||= user.default_address
      end
    end
  end
end
