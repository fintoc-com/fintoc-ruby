require 'fintoc/base_client'
require 'fintoc/v1/managers/links_manager'

module Fintoc
  module V1
    class Client < BaseClient
      def links
        @links ||= Managers::LinksManager.new(self)
      end
    end
  end
end
