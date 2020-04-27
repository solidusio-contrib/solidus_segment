# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Serializers::CommonSerializer do
  describe "#to_h" do
    it "returns empty hash when user and request aren't given" do
      expect(described_class.new.to_h).to be_empty
    end

    it "returns only the user_id when only the user is given" do
      user = build_stubbed(:user, id: 1)

      params = described_class.new(user: user).to_h

      expect(params).to eq(user_id: 1)
    end

    it "parses the user and request and returns the parameters" do
      user = build_stubbed(:user, id: 1)
      request = ActionDispatch::TestRequest.create
      request.cookies["_ga"] = "GA1.2.1033501218.1368477899"
      request.session_options[:id] = "123"

      params = described_class.new(user: user, request: request).to_h

      expect(params).to eq(
        user_id: 1,
        anonymous_id: "123",
        integrations: {
          "Google Analytics" => {
            clientId: "1033501218.1368477899"
          }
        },
        context: {
          user_agent: "Rails Testing"
        }
      )
    end
  end
end
