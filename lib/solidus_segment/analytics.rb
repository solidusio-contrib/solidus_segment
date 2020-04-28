# frozen_string_literal: true

module SolidusSegment
  class Analytics
    attr_reader :backend

    def initialize(user: nil,
                   anonymous_id: nil,
                   client_id: nil,
                   backend: SolidusSegment.configuration.segment_backend)
      @user = user
      @anonymous_id = anonymous_id
      @client_id = client_id
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
      track "Order Completed", properties: Serializers::OrderSerializer.new(order).to_h
    end

    private

    attr_reader :user, :anonymous_id, :client_id

    def common_params
      {
        user_id: user&.id,
        anonymous_id: anonymous_id,
        integrations: integrations
      }
    end

    def traits
      return unless user

      Serializers::TraitsSerializer.new(user).to_h
    end

    def integrations
      return unless client_id

      Hash['Google Analytics': { clientId: client_id }]
    end
  end
end
