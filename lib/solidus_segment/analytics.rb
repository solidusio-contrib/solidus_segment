# frozen_string_literal: true

module SolidusSegment
  class Analytics
    attr_reader :backend

    def initialize(user: nil,
                   request: nil,
                   backend: SolidusSegment.configuration.segment_backend)
      @user = user
      @common_params = CommonParameters.new(user: user, request: request).to_h
      @backend = backend
    end

    def identify(**args)
      backend.identify(common_params.merge(traits: traits).merge(args).compact)
    end

    def track(event, **args)
      backend.track(common_params.merge(event: event).merge(args).compact)
    end

    def track_order_completed(order:)
      identify
      track Events::ORDER_COMPLETED, properties: Serializers::OrderSerializer.new(order).to_h
    end

    private

    attr_reader :user, :common_params

    def traits
      return unless user

      Serializers::TraitsSerializer.new(user).to_h
    end
  end
end
