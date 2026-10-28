require 'fintoc/base_client'
require 'fintoc/v2/managers/entities_manager'
require 'fintoc/v2/managers/recipients_manager'
require 'fintoc/v2/managers/accounts_manager'
require 'fintoc/v2/managers/account_numbers_manager'
require 'fintoc/v2/managers/transfers_manager'
require 'fintoc/v2/managers/transfer_batches_manager'
require 'fintoc/v2/managers/simulate_manager'
require 'fintoc/v2/managers/account_verifications_manager'
require 'fintoc/v2/managers/customers_manager'
require 'fintoc/v2/managers/products_manager'
require 'fintoc/v2/managers/checkout_sessions_manager'
require 'fintoc/v2/managers/payment_intents_manager'
require 'fintoc/v2/managers/payment_methods_manager'
require 'fintoc/v2/managers/setup_intents_manager'
require 'fintoc/v2/managers/events_manager'
require 'fintoc/v2/managers/invoices_manager'
require 'fintoc/v2/managers/subscriptions_manager'

module Fintoc
  module V2
    class Client < BaseClient
      def entities
        @entities ||= Managers::EntitiesManager.new(self)
      end

      def recipients
        @recipients ||= Managers::RecipientsManager.new(self)
      end

      def accounts
        @accounts ||= Managers::AccountsManager.new(self)
      end

      def account_numbers
        @account_numbers ||= Managers::AccountNumbersManager.new(self)
      end

      def transfers
        @transfers ||= Managers::TransfersManager.new(self)
      end

      def transfer_batches
        @transfer_batches ||= Managers::TransferBatchesManager.new(self)
      end

      def simulate
        @simulate ||= Managers::SimulateManager.new(self)
      end

      def account_verifications
        @account_verifications ||= Managers::AccountVerificationsManager.new(self)
      end

      def customers
        @customers ||= Managers::CustomersManager.new(self)
      end

      def products
        @products ||= Managers::ProductsManager.new(self)
      end

      def checkout_sessions
        @checkout_sessions ||= Managers::CheckoutSessionsManager.new(self)
      end

      def payment_intents
        @payment_intents ||= Managers::PaymentIntentsManager.new(self)
      end

      def payment_methods
        @payment_methods ||= Managers::PaymentMethodsManager.new(self)
      end

      def setup_intents
        @setup_intents ||= Managers::SetupIntentsManager.new(self)
      end

      def events
        @events ||= Managers::EventsManager.new(self)
      end

      def invoices
        @invoices ||= Managers::InvoicesManager.new(self)
      end

      def subscriptions
        @subscriptions ||= Managers::SubscriptionsManager.new(self)
      end
    end
  end
end
