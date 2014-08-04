module Spree
  module Admin
    class ScanAndGoController < Spree::Admin::BaseController
      def redirect
        input = params[:scan_and_go_input]

        case input
        when /^RMA/
          if rma = Spree::ReturnAuthorization.find_by(number: input)
            redirect = edit_admin_order_return_authorization_path(rma.order, rma)
          else
            error = t(:couldnt_find_rma)
          end
        when /^R/
          if order = Spree::Order.find_by(number: input)
            redirect = edit_admin_order_path(order)
          else
            error = t(:couldnt_find_order)
          end
        when /^H/
          if shipment = Spree::Shipment.find_by(number: input)
            # Since the shipment has no detail page we redirect to the order
            redirect = edit_admin_order_path(shipment.order)
          else
            error = t(:couldnt_find_shipment)
          end
        when /@/
          if user = Spree::User.find_by(email: input)
            redirect = edit_admin_user_path(user)
          else
            error = t(:couldnt_find_user)
          end
        when /^[0-9]/
          if product = Spree::Product.find_by_id(input)
            redirect = edit_admin_product_path(product)
          else
            error = t(:couldnt_find_product)
          end
        else
          error = t(:couldnt_handle_scan_and_go_input)
        end

        flash[:error] = error if error
        redirect_to redirect ? redirect : :back
      end
    end
  end
end
