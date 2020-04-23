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

    def identify
      backend.identify(identify_params)
    end

    private

    attr_reader :user, :anonymous_id, :client_id

    def identify_params
      {
        user_id: user&.id,
        anonymous_id: anonymous_id,
        traits: traits,
        integrations: integrations
      }.compact
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
