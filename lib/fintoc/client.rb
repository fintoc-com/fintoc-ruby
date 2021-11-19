require 'faraday'

module Fintoc
  class Client
    def initialize(base_url, api_key, user_agent, params={})
      @base_url = base_url
      @api_key = api_key
      @user_agent = user_agent
      @params = params
      @_client = nil
    end

    def client
      if @_client.nil?
        @_client = Faraday.new(
          url: @base_url,
          headers: @headers,
          params: @params
        )
      end
      return @_client
    end

    def headers
      return { Authorization: @api_key, 'User-Agent': @user_agent }
    end

    def extend(base_url=nil, api_key=nil, user_agent=nil, params=nil)
      return Client.new(
        base_url=base_url || @base_url,
        api_key=api_key || @api_key,
        user_agent=user_agent || @user_agent,
        params=params ? {**@params, **params} : @params,
      )
    end
  end
end
