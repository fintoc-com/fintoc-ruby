require 'fintoc/base_client'
require 'fintoc/v1/managers/links_manager'
require 'fintoc/v1/managers/webhook_endpoints_manager'
require 'fintoc/v1/managers/accounts_manager'
require 'fintoc/v1/managers/movements_manager'
require 'fintoc/v1/managers/institutions_manager'
require 'fintoc/v1/managers/link_intents_manager'
require 'fintoc/v1/managers/refresh_intents_manager'
require 'fintoc/v1/managers/tax_returns_manager'
require 'fintoc/v1/managers/tax_statements_manager'
require 'fintoc/v1/managers/invoices_manager'

module Fintoc
  module V1
    class Client < BaseClient
      def links
        @links ||= Managers::LinksManager.new(self)
      end

      def webhook_endpoints
        @webhook_endpoints ||= Managers::WebhookEndpointsManager.new(self)
      end

      def accounts
        @accounts ||= Managers::AccountsManager.new(self)
      end

      def movements
        @movements ||= Managers::MovementsManager.new(self)
      end

      def institutions
        @institutions ||= Managers::InstitutionsManager.new(self)
      end

      def link_intents
        @link_intents ||= Managers::LinkIntentsManager.new(self)
      end

      def refresh_intents
        @refresh_intents ||= Managers::RefreshIntentsManager.new(self)
      end

      def tax_returns
        @tax_returns ||= Managers::TaxReturnsManager.new(self)
      end

      def tax_statements
        @tax_statements ||= Managers::TaxStatementsManager.new(self)
      end

      def invoices
        @invoices ||= Managers::InvoicesManager.new(self)
      end
    end
  end
end
