require 'fintoc/clients/movements_client'
require 'fintoc/clients/transfers_client'

module Fintoc
  class Client
    attr_reader :movements, :transfers

    def initialize(api_key)
      @movements = Clients::MovementsClient.new(api_key)
      @transfers = Clients::TransfersClient.new(api_key)
    end

    # Delegate common methods to maintain backward compatibility
    def get_link(link_token)
      @movements.get_link(link_token)
    end

    def get_links
      @movements.get_links
    end

    def delete_link(link_id)
      @movements.delete_link(link_id)
    end

    def get_account(link_token, account_id)
      @movements.get_account(link_token, account_id)
    end

    def get_entity(entity_id)
      @transfers.get_entity(entity_id)
    end

    def get_entities(**params)
      @transfers.get_entities(**params)
    end

    def to_s
      "Fintoc::Client(movements: #{@movements}, transfers: #{@transfers})"
    end
  end
end
