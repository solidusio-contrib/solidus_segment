# frozen_string_literal: true

module SolidusSegment
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_segment\n" # rubocop:disable Metrics/LineLength
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/solidus_segment\n" # rubocop:disable Metrics/LineLength
      end
    end
  end
end
