# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Analytics do
  before do
    SolidusSegment.configuration.segment_write_key = 123
    SolidusSegment.configuration.segment_backend = nil
  end

  it "uses the configured backend by default" do
    expect(described_class.new.backend).to eq(SolidusSegment.configuration.segment_backend)
  end

  it "accepts setting backend as initializer argument" do
    SolidusSegment.configuration.segment_backend = instance_double("ConfiguredBackend::Analytics")

    backend = instance_double("Backend::Analytics")

    expect(described_class.new(backend: backend).backend).to eq(backend)
  end
end
