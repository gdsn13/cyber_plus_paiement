module Spree
  class PaymentMethods::CyberPlusPaiementController < ApplicationController
    #include ERB::Util
    helper Spree::BaseHelper

    skip_before_filter :verify_authenticity_token, :only => [:callback, :comeback]

    def show
      @order = Order.find(params[:order_id])
      @payment_method = PaymentMethod.find(params[:gateway_id])
      @order.payments.destroy_all
      payment = @order.payments.create!(:amount => @order.total, :payment_method_id => @payment_method.id)

      if @order.blank? || @payment_method.blank?
        flash[:error] = t("cyber_plus_paiement.invalid_arguments")
        redirect_to checkout_url
      else
        @bill_address, @ship_address = @order.bill_address, (@order.ship_address || @order.bill_address)
      end
    end

    def callback
      if params[:vads_order_id] && @order=Order.find(params[:vads_order_id])
        msg = response_treatment(@order, params, true)

        if @order.completed?
          render :text => t('cyber_plus_paiement.payment_success_callback')
        else
          render :text => t('cyber_plus_paiement.payment_error_callback', :msg => msg)
        end
      else
        render :text => t('cyber_plus_paiement.payment_error_order_not_found')
      end
    end

    def comeback
      if params[:vads_order_id] && @order=Order.find(params[:vads_order_id])
        msg = response_treatment(@order, params, true)

        if @order.completed?
          session[:order_id] = nil
          flash[:error] = msg
          redirect_to order_url(@order)
        else
          flash[:error] = msg
          redirect_to checkout_state_path("payment")
        end
      else
        flash[:error] = t('cyber_plus_paiement.payment_error_order_not_found')
        redirect_to root_url
      end

    
    end

    private

    def response_treatment(order, params, check_complete_later=false)

      # Check if the order is not complete or if we just want to check that later in the process and also escape the
      # message linked to an order already complete). It is usefull in the case of 'comeback' has we want the message
      # corresponding to the request statement and not directly the order statement

      if order.completed? || check_complete_later
        if (payment_method=order.payments.first.payment_method) && payment_method.kind_of?(PaymentMethod::CyberPlusPaiement)
          # SECURITY : Verifying the signature from the request
          if params[:signature] == payment_method.generate_signature(params)
            # SECURITY : Verifying that the amount paid and the amount on the order are equals
            # (actually useless after the signature checking but still ...)
            if params[:vads_amount].to_i == (order.total.to_f * 100).to_i
              # Check if the payment has been validated
              if params[:vads_result] == "00"
                # If we just want the msg, we should skip the payement process, but in case the order hasn't been
                # completed as it should (callback late ?!), we should proceed the payement here
                if !order.completed?
                  
                  payment = PaymentMethod::CyberPlusPaiement.process_payment(order, payment_method, params)

                  if payment.completed?
                    return t('cyber_plus_paiement.payment_success')
                  else
                    return t("Order not Finalized, Payment status : #{payment.state}")
                  end
                end

                return t('cyber_plus_paiement.payment_success')
              else
                return t('cyber_plus_paiement.payment_error_refused')+payment_error(params)
              end
            elsif params[:vads_result] == "00"
              return t('cyber_plus_paiement.payment_error_secu_amount_paid', :o_amount => (order.total.to_f *100).to_i.to_s, :r_amount => params[:vads_amount].to_s)
            else
              return t('cyber_plus_paiement.payment_error_secu_amount_not_paid', :o_amount => (order.total.to_f *100).to_i.to_s, :r_amount => params[:vads_amount].to_s)+payment_error(params)
            end
          elsif params[:vads_result] == "00"
            return t('cyber_plus_paiement.payment_error_secu_signature_paid')
          else
            return t('cyber_plus_paiement.payment_error_secu_signature_not_paid')+payment_error(params)
          end
        else
          return t('cyber_plus_paiement.payment_error_gateway')
        end
      else
        return t('cyber_plus_paiement.payment_error_already')
      end
    end

    def payment_error(data)
      res = t('cyber_plus_paiement.payment_error_server_trace')
      res += PaymentMethod::CyberPlusPaiement::VADS_RESULT_TAB[data[:vads_result]].to_s
      res += " (#{PaymentMethod::CyberPlusPaiement::VADS_EXTRA_RESULT_TAB[data[:vads_extra_result]]})" unless data[:vads_extra_result].empty?
      return res.html_safe
    end
  end
end