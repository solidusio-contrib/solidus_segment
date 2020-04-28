# frozen_string_literal: true

module SolidusSegment
  module CheckoutController
    module AddEvents
      def finalize_order
        Spree::Event.fire SolidusSegment::Events::ORDER_COMPLETED,
          request: request,
          user: spree_current_user,
          order: current_order

        super
      end

      ::Spree::CheckoutController.prepend self
    end
  end
end
