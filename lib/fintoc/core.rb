require_relative "client.rb"
require_relative "constants.rb"
require_relative "version.rb"

module Fintoc
  class Fintoc
    def initialize(api_key)
      @_client = Client.new(
        base_url="#{Constants::API_BASE_URL}/#{Constants::API_VERSION}",
        api_key=api_key,
        user_agent="fintoc-ruby/#{VERSION}"
      )
    end
  end
end
