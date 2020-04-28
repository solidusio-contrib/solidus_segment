# frozen_string_literal: true

module SolidusSegment
  class SolidusEventParser
    def initialize(payload)
      @request = payload[:request]
      @user = payload[:user]
    end

    def to_params
      { user: user, anonymous_id: anonymous_id, client_id: client_id }
    end

    private

    attr_reader :request, :user

    def anonymous_id
      request.session_options[:id]
    end

    def client_id
      request.cookies["_ga"]&.gsub(/^GA\d\.\d\./, '')
    end
  end
end
