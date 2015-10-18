= Cyber Plus Paiement

Cyber Plus Paiement Extension allow to integrate Cyber Plus Paiement as a payment method in Spree.
This extension has been based on the work of two Github projects :
- https://github.com/bryanmtl/spree_clear2pay_gateway
- https://github.com/pronix/spree-ebsin
So thanks to their authors and commiters.

== Presentation
Once you have selected that payment method, you will be redirected to the secure servers to proceed your payment by credit card.

== Configuration
- login : Identifier given by your CyberPlusPaiement service
- URL : URL to access the secure servers and proceed the payment
- cert_for_test : Cetificate used in test environment and given by your CyberPlusPaiement service
- cert_for_prod : Cetificate used in production environment and given by your CyberPlusPaiement service

== TODO
- Give a proper trans_id (and not the time hack, problem if transaction in the same second ...)
- Manage properly the error from the controller (Spree log ?)
- Allow to configure a bit more the request (currency, ...)
- and ... TEST THE EXTENTION (Scenario cases for the payment mandatory )
- Put the business logic inside the model