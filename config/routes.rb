# Put your extension routes here.

Spree::Core::Engine.routes.draw do
  scope module: 'payment_methods' do
    get '/cyber_plus_paiement/:gateway_id/:order_id', controller: 'cyber_plus_paiement', action: 'show', as: :gateway_cyber_plus_paiement
    post '/cyber_plus_paiement/callback', controller: 'cyber_plus_paiement', action: 'callback'
    get '/cyber_plus_paiement/comeback', controller: 'cyber_plus_paiement', action: 'comeback'
  end
end