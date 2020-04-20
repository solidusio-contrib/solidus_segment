# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Configuration do
  it 'can be accessed by SolidusSegment::configuration' do
    expect(SolidusSegment.configuration).to be_instance_of described_class
  end

  describe "#segment_backend" do
    subject(:configuration) { described_class.new }

    it "returns the configured backend" do
      backend = instance_double('Backend::Analytics')
      configuration.segment_backend = backend

      expect(configuration.segment_backend).to eq(backend)
    end

    it "raises SolidusSegment::Configuration::Error when analytics-ruby gem is not present" do
      hide_const('Segment::Analytics')

      expect{ configuration.segment_backend }.to raise_error(SolidusSegment::Configuration::Error)
    end

    context "when analytics-ruby gem is present" do
      it "returns an instance of Segment::Analytics" do
        configuration.segment_write_key = '123'
        expect(configuration.segment_backend).to be_a(Segment::Analytics)
      end

      it "instantiaes Segment::Analytics with the configured segment_write_key" do
        configuration.segment_write_key = '123'
        allow(Segment::Analytics).to receive(:new)

        configuration.segment_backend

        expect(Segment::Analytics).to have_received(:new).with(write_key: '123')
      end

      it "raises an error when the write key is missing " do
        expect{ configuration.segment_backend }.to raise_error(ArgumentError)
      end
    end
  end
end
