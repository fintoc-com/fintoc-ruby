require 'fintoc/base_client'
require 'fintoc/transfers/managers/entities_manager'
require 'fintoc/transfers/managers/accounts_manager'
require 'fintoc/transfers/managers/account_numbers_manager'
require 'fintoc/transfers/managers/transfers_manager'
require 'fintoc/transfers/managers/simulate_manager'
require 'fintoc/transfers/managers/account_verifications_manager'

module Fintoc
  module Transfers
    class Client < BaseClient
      def entities
        @entities ||= Managers::EntitiesManager.new(self)
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

      def simulate
        @simulate ||= Managers::SimulateManager.new(self)
      end

      def account_verifications
        @account_verifications ||= Managers::AccountVerificationsManager.new(self)
      end
    end
  end
end
