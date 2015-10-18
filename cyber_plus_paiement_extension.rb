class CyberPlusPaiementExtension < Spree::Extension
  version "1.0"
  description "Support for the CyberPlusPaimenent gateway"
  url "soon"

  def activate
    #require File.join(CyberPlusPaiementExtension.root, "lib", "active_merchant", "billing", "gateways", "cyber_plus_paiement.rb")
    #Gateway::CyberPlusPaiement.register
    PaymentMethod::CyberPlusPaiement.register

    Spree::BaseController.class_eval do
      helper CyberPlusPaiementHelper
    end

    # inject paypal code into orders controller
    CheckoutsController.class_eval do
      #include ERB::Util
      # include ActiveMerchant::RequiresParameters

      before_filter :redirect_for_cyber_plus_paiement
#      before_filter :load_data, :except => [:payment_success, :payment_failure]
      def redirect_for_cyber_plus_paiement
        if object.payment?
          if PaymentMethod.find(params[:checkout][:payments_attributes].first[:payment_method_id].to_i).class.to_s == 'PaymentMethod::CyberPlusPaiement'
            payment_method = params[:checkout][:payments_attributes].first[:payment_method_id].to_i
            redirect_to(gateway_cyber_plus_paiement_url(:gateway_id => payment_method, :order_id => @order.id)) and return
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

    Creditcard.class_eval do

      def process!(payment)
        return true
      end

    end

  end

end
