# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Subscriber do
  before { SolidusSegment.configuration.segment_write_key = 123 }

  describe "'Order Completed' event" do
    it "tracks the event with the analytics class" do
      order = build(:order)
      request = ActionDispatch::TestRequest.create
      request.session_options[:id] = "123"

      expect_any_instance_of(SolidusSegment::Analytics).
        to receive(:track_order_completed).and_call_original

      Spree::Event.fire SolidusSegment::Events::ORDER_COMPLETED, request: request, order: order
    end
  end
end
