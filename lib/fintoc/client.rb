require 'fintoc/movements/client/client'
require 'fintoc/transfers/client/client'

module Fintoc
  class Client
    # Deprecated in favor of Fintoc::Movements::Client and Fintoc::Transfers::Client
    # It should not be used anymore, but it will be kept for now for backward compatibility

    attr_reader :movements, :transfers

    def initialize(api_key, jws_private_key: nil)
      @movements = Fintoc::Movements::Client.new(api_key)
      @transfers = Fintoc::Transfers::Client.new(api_key, jws_private_key: jws_private_key)
    end

    # Delegate common methods to maintain backward compatibility
    def get_link(link_token)
      @movements.links.get(link_token)
    end

    def get_links
      @movements.links.list
    end

    def delete_link(link_id)
      @movements.links.delete(link_id)
    end

    def get_account(link_token, account_id)
      @movements.links.get(link_token).find(id: account_id)
    end

    def to_s
      "Fintoc::Client(movements: #{@movements}, transfers: #{@transfers})"
    end
  end
end
