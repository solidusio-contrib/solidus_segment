# frozen_string_literal: true

module SolidusSegment
  module Subscriber
    include Spree::Event::Subscriber

    event_action :track_order_completed, event_name: SolidusSegment::Events::ORDER_COMPLETED

    def track_order_completed(event)
      SolidusSegment::Analytics.new(
        SolidusEventParser.new(event.payload).to_params
      ).track_order_completed(order: event.payload[:order])
    end
  end
end

SolidusSegment::Subscriber.subscribe!
