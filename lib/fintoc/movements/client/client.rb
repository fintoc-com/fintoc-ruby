require 'fintoc/base_client'
require 'fintoc/movements/managers/links_manager'

module Fintoc
  module Movements
    class Client < BaseClient
      def links
        @links ||= Managers::LinksManager.new(self)
      end
    end
  end
end
