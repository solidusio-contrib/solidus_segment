# frozen_string_literal: true

module SolidusSegment
  class Analytics
    attr_reader :backend

    def initialize(user: nil,
                   anonymous_id: nil,
                   backend: SolidusSegment.configuration.segment_backend)
      @user = user
      @anonymous_id = anonymous_id
      @backend = backend
    end

    def identify
      backend.identify(identify_params)
    end

    private

    attr_reader :user, :anonymous_id

    def identify_params
      {
        user_id: user&.id,
        anonymous_id: anonymous_id,
      }
    end
  end
end
