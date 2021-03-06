require 'digest/sha1'

module Spree
  class PaymentMethod::CyberPlusPaiement < PaymentMethod
    preference :login, :string
    preference :url, :string, :default => 'https://systempay.cyberpluspaiement.com/vads-payment/'
    preference :test_mode, :boolean, :default => true
    preference :cert_for_test, :string
    preference :cert_for_prod, :string

    VADS_RESULT_TAB = {
      '00' => 'Paiement réalisé avec succès.',
      '02' => 'Le commerçant doit contacter la banque du porteur.',
      '05' => 'Paiement refusé.',
      '17' => 'Annulation client.',
      '30' => 'Erreur de format de la requête.',
      '96' => 'Erreur technique lors du paiement.'
    }

    VADS_EXTRA_RESULT_TAB = {
      '00' => 'Tous les contrôles se sont déroulés avec succès.',
      '02' => 'La carte a dépassé l’encours autorisé.',
      '03' => 'La carte appartient à la liste grise du commerçant',
      '04' => 'Le pays d’émission de la carte appartient à la liste grise du commerçant ou le pays d’émission de la carte n’appartient pas à la liste blanche du commerçant.',
      '05' => 'L’adresse IP appartient à la liste grise du commerçant.',
      '07' => 'La carte appartient à la liste grise BIN du commerçant.',
      '99' => 'Problème technique rencontré par le serveur lors du traitement d’un des contrôles locaux.'
    }

    def payment_profiles_supported?
      false
    end

    def test?
      preferred_test_mode
    end

    def build_request(order)
      data = {}
      data['vads_action_mode'] = 'INTERACTIVE'
      data['vads_amount'] = (order.total.to_f * 100).to_i
      data['vads_ctx_mode'] = (self.test? ? 'TEST' : 'PRODUCTION')
      data['vads_currency'] = 978
      data['vads_cust_email'] = order.user.email
      data['vads_order_id'] = order.id
      data['vads_page_action'] = 'PAYMENT'
      data['vads_payment_config'] = 'SINGLE'
      data['vads_return_mode'] = 'GET'
      data['vads_site_id'] = self.preferred_login
      data['vads_trans_date'] = Time.now.strftime("%Y%m%d%H%M%S")
      data['vads_trans_id'] = Time.now.strftime("%H%M%S")
      data['vads_validation_mode'] = 0
      data['vads_version'] = 'V2'
      data['signature'] = self.generate_signature(data)
      return data
    end

    def generate_signature(data)
      key = ''
      data.keys.sort.each do |k|
        if k.to_s.split('_').first == 'vads'
          key += data[k].to_s+'+'
        end
      end
      key += (self.test? ? self.preferred_cert_for_test : self.preferred_cert_for_prod)
      return Digest::SHA1.hexdigest(key)
    end

    def self.process_payment(order, payment_method, data)

      payment = order.payments.where(:payment_method_id => payment_method.id).last
      payment.amount = order.total
      order.payment_total = order.total

      unless payment
        payment = order.payments.create({:amount => order.total,
                                         :source => payment_method.id,
                                         :payment_method => payment_method},
                                         :without_protection => true)
        payment.started_processing!
        payment.pend!
      end

      unless payment.completed?
        payment.complete!        
      end

      order.update_attributes({:state => "complete", :completed_at => Time.now})

      until order.state == "complete"
        if order.next!
          order.update!
          state_callback(:after)
        end
      end

      order.finalize!       

      return payment
    end
  end
end