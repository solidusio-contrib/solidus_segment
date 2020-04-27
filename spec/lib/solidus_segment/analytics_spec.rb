# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Analytics do
  let(:user) { build_stubbed(:user) }

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

  describe "#identify" do
    context 'when the defaul backend is used' do
      it "raises an error if user and anonymous_id aren't given" do
        expect{ described_class.new.identify }.to raise_error(ArgumentError)
      end

      it "doesn't raise an error if only the user is given" do
        expect{ described_class.new(user: user).identify }.not_to raise_error
      end

      it "doesn't raise an error if only the anonymous_id is given" do
        expect{ described_class.new(anonymous_id: 'abc').identify }.not_to raise_error
      end
    end

    it "identifies the user by id and anonymous_id with user traits" do
      backend = instance_double('Backend::Analytics')
      allow(backend).to receive(:identify)

      described_class.new(user: user, anonymous_id: 'abc', backend: backend).identify

      expect(backend).to have_received(:identify).with(
        user_id: user.id,
        anonymous_id: 'abc',
        traits: instance_of(Hash)
      )
    end

    it "when user isn't given identifies the user without user_id and traits" do
      backend = instance_double('Backend::Analytics')
      allow(backend).to receive(:identify)

      described_class.new(anonymous_id: 'abc', backend: backend).identify

      expect(backend).to have_received(:identify).with(anonymous_id: 'abc')
    end

    it "when client_id is given identifies the user also with integrations" do
      backend = instance_double('Backend::Analytics')
      allow(backend).to receive(:identify)

      described_class.new(anonymous_id: 'abc', client_id: '123', backend: backend).identify

      expect(backend).to have_received(:identify).with(
        anonymous_id: 'abc',
        integrations: { "Google Analytics": { clientId: "123" } }
      )
    end

    it "when traits are given merges it with the common traits" do
      backend = instance_double('Backend::Analytics')
      allow(backend).to receive(:identify)

      described_class.new(anonymous_id: 'abc', backend: backend).identify(traits: { email: "admin@example.com" })

      expect(backend).to have_received(:identify).with(
        anonymous_id: 'abc',
        traits: { email: "admin@example.com" }
      )
    end
  end

  describe "#track_order_completed" do
    it "identifies the user" do
      analytics = described_class.new(anonymous_id: "abc")
      allow(analytics).to receive(:identify)
      allow(analytics).to receive(:track)

      analytics.track_order_completed(order: build_stubbed(:order))

      expect(analytics).to have_received(:identify)
    end

    it "sends the 'Order Completed' event with properties" do
      backend = object_spy("Backend::Analytics")

      described_class.new(backend: backend).
        track_order_completed(order: build_stubbed(:order))

      expect(backend.as_null_object).to have_received(:track).with(
        hash_including(event: "Order Completed", properties: an_instance_of(Hash))
      )
    end

    it "sends the user by id and anonymous_id" do
      backend = object_spy("Backend::Analytics")

      described_class.new(user: user, anonymous_id: "abc", backend: backend).
        track_order_completed(order: build_stubbed(:order))

      expect(backend.as_null_object).to have_received(:track).with(
        hash_including(user_id: user.id, anonymous_id: "abc")
      )
    end

    it "when client_id is given sends the integrations" do
      backend = object_spy("Backend::Analytics")

      described_class.new(anonymous_id: "abc", client_id: "123", backend: backend).
        track_order_completed(order: build_stubbed(:order))

      expect(backend.as_null_object).to have_received(:track).with(
        hash_including(integrations: { "Google Analytics": { clientId: "123" } })
      )
    end
  end
end
