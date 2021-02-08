# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusSegment::Serializers::TraitsSerializer do
  let(:user) { build_stubbed(:user, id: 1, email: "admin@example.com", login: "admin") }

  describe "#to_h" do
    it "returns an hash with reserved traits keys" do
      user.ship_address = create(:address, zipcode: '12345')
      serializer = described_class.new(user).to_h

      expect(serializer).to include(
        address: instance_of(Hash),
        created_at: user.created_at,
        email: 'admin@example.com',
        id: 1,
        phone: '555-555-0199',
        username: 'admin',
      )
    end

    it "removes the element in case the value is empty" do
      user.login = nil
      serializer = described_class.new(user).to_h

      expect(serializer).not_to have_key(:username)
    end
  end
end
