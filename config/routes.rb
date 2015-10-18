# Put your extension routes here.

# map.namespace :admin do |admin|
#   admin.resources :whatever
# end

map.namespace :gateway do |gateway|
  gateway.cyber_plus_paiement '/cyber_plus_paiement/:gateway_id/:order_id', :controller => 'cyber_plus_paiement', :action => 'show'
  gateway.cyber_plus_paiement_callback '/cyber_plus_paiement/callback', :controller => 'cyber_plus_paiement', :action => 'callback'
  gateway.cyber_plus_paiement_comeback '/cyber_plus_paiement/comeback', :controller => 'cyber_plus_paiement', :action => 'comeback'
end