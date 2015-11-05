module Spree
  CheckoutController.class_eval do
    #include ERB::Util
    # include ActiveMerchant::RequiresParameters

    before_filter :redirect_for_cyber_plus_paiement

    def redirect_for_cyber_plus_paiement
      if params[:state] == 'payment' && action_name = 'update' && @order.payment?
        if @order.payments.last.present? && @order.payments.last.payment_method.class.to_s == 'Spree::PaymentMethod::CyberPlusPaiement'
          payment_method = @order.payments.last.payment_method
          redirect_to(gateway_cyber_plus_paiement_url(gateway_id: payment_method.id, order_id: @order.id)) and return
        end
      end
    end
  end
end