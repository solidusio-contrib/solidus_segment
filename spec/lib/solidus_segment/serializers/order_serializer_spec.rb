# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Serializers::OrderSerializer do
  let(:order) { create(:completed_order_with_totals, id: 1, number: "R756187", coupon_code: '123') }

  describe "#to_h" do
    it "returns an hash with the order fields to track" do
      serializer = described_class.new(order).to_h

      expect(serializer).to include(
        checkout_id: "R756187",
        order_id: 1,
        shipping: 100.0.to_d,
        tax: 0.0,
        discount: 0.0,
        total: 110.0.to_d,
        revenue: 10.0.to_d,
        currency: "USD",
        coupon: '123',
        products: instance_of(Array),
      )
    end

    it "removes the element in case the value is empty" do
      order.coupon_code = nil
      serializer = described_class.new(order).to_h

      expect(serializer).not_to have_key(:coupon)
    end
  end
end
