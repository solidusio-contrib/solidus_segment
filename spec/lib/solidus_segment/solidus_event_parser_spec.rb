# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::SolidusEventParser do
  describe "#to_params" do
    it "raises an error when the request isn't given" do
      expect{ described_class.new(request: nil).to_params }.to raise_error(NoMethodError)
    end

    it "doesn't raise an error when the user isn't given" do
      request = ActionDispatch::TestRequest.create

      expect{ described_class.new(request: request).to_params }.not_to raise_error
    end

    it "parses the event payload and returns the parameters" do
      user = build_stubbed(:user)
      request = ActionDispatch::TestRequest.create
      request.cookies["_ga"] = "GA1.2.1033501218.1368477899"
      request.session_options[:id] = "123"

      params = described_class.new(user: user, request: request).to_params

      expect(params).to eq(user: user, client_id: "1033501218.1368477899", anonymous_id: "123")
    end
  end
end
