require_relative 'client'
require_relative 'constants'
require_relative 'version'

module Fintoc
  class Fintoc
    def initialize(api_key)
      @client = Client.new(
        base_url: "#{Constants::API_BASE_URL}/#{Constants::API_VERSION}",
        api_key: api_key,
        user_agent: "fintoc-ruby/#{VERSION}"
      )
    end
  end
end
