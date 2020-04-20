# frozen_string_literal: true

module SolidusSegment
  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class Configuration
    attr_writer :segment_backend
    attr_accessor :segment_write_key

    class Error < NameError
      def message
        <<-MESSAGE
          Please configure the Segment backend or install analytics-ruby
          (https://github.com/segmentio/analytics-ruby) to use the default one.
        MESSAGE
      end
    end

    def segment_backend
      @segment_backend ||= Segment::Analytics.new(write_key: segment_write_key)
    rescue NameError
      raise SolidusSegment::Configuration::Error
    end
  end
end
