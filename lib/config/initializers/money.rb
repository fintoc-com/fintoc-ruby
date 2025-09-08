require 'money-rails'

MoneyRails.configure do |config|
  config.locale_backend = :currency
end
