# frozen_string_literal: true

module SolidusSegment
  class Analytics
    attr_reader :backend

    def initialize(backend: SolidusSegment.configuration.segment_backend)
      @backend = backend
    end
  end
end
