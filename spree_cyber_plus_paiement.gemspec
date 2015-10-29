# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree_cyber_plus_paiement/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_cyber_plus_paiement'
  s.version     = SpreeCyberPlusPaiement::VERSION
  s.summary     = 'SystemPay CyberPlus Gateway for Spree plateform'
  s.description = 'Please check again summary'
  s.required_ruby_version = '>= 1.9.3'

  s.authors     = ["Fran\303\247ois Turbelin"]
  s.email       = ["pacodelaluna@gmail.com"]
  # s.homepage    = 'http://www.spreecommerce.com'
  # s.license     = "MIT"

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4.10'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
