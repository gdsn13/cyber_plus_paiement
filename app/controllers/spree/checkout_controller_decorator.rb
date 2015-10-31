module Spree
  CheckoutController.class_eval do
    #include ERB::Util
    # include ActiveMerchant::RequiresParameters

    before_filter :redirect_for_cyber_plus_paiement
#      before_filter :load_data, :except => [:payment_success, :payment_failure]
    def redirect_for_cyber_plus_paiement
      if params[:state] == 'payment' && action_name = 'update' && @order.payment?
        if @order.payments.last.present? && @order.payments.last.payment_method.class.to_s == 'Spree::PaymentMethod::CyberPlusPaiement'
          payment_method = @order.payments.last.payment_method
          redirect_to(gateway_cyber_plus_paiement_url(gateway_id: payment_method.id, order_id: @order.id)) and return
        end
      end
      ##
#        return unless params[:state] == "payment"
#        @payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
#        if @payment_method && @payment_method.kind_of?(PaymentMethod::CreditPlusPayment)
#          redirect_to gateway_credit_plus_payment_path(:gateway_id => @payment_method.id, :order_id => @order.id)
#        end
    end

#      def clearpay_payment
#        load_object
#        @gateway = payment_method
#      end
#
#      def payment_success
#        load_object
#        @gateway = payment_method
#      end
#
#      def payment_failure
#        load_object
#        @gateway = payment_method
#      end
#
#        # create the gateway from the supplied options
#      def payment_method
#        PaymentMethod.find(params[:payment_method_id])
#      end
#
#      def payment_success
#        @order = Order.find_by_number(params[:order_id])
#        session[:order_id] = nil
#        flash[:commerce_tracking] = I18n.t("notice_messages.track_me_in_GA")
#      end

  end
end