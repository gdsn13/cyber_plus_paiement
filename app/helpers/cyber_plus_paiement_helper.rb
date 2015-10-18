module CyberPlusPaiementHelper

  def build_form_data(payment_method, order)
    res = ''
    payment_method.build_request(order).each{ |k, v| res += hidden_field_tag(k.to_s, v) }
    return res

  end

end
