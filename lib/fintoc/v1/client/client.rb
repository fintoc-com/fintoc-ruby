require 'fintoc/base_client'
require 'fintoc/v1/managers/links_manager'
require 'fintoc/v1/managers/webhook_endpoints_manager'

module Fintoc
  module V1
    class Client < BaseClient
      def links
        @links ||= Managers::LinksManager.new(self)
      end

      def webhook_endpoints
        @webhook_endpoints ||= Managers::WebhookEndpointsManager.new(self)
      end
    end
  end
end
