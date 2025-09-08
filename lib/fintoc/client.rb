require 'fintoc/v1/client/client'
require 'fintoc/v2/client/client'

module Fintoc
  class Client
    def initialize(api_key, jws_private_key: nil)
      @api_key = api_key
      @jws_private_key = jws_private_key
    end

    def v1
      @v1 ||= Fintoc::V1::Client.new(@api_key)
    end

    def v2
      @v2 ||= Fintoc::V2::Client.new(@api_key, jws_private_key: @jws_private_key)
    end

    # These methods are kept for backward compatibility
    def get_link(link_token)
      @v1.links.get(link_token)
    end

    def get_links
      @v1.links.list
    end

    def delete_link(link_id)
      @v1.links.delete(link_id)
    end

    def get_account(link_token, account_id)
      @v1.links.get(link_token).find(id: account_id)
    end

    def to_s
      "Fintoc::Client(v1: #{@v1}, v2: #{@v2})"
    end
  end
end
