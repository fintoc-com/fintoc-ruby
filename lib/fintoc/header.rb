require 'fintoc/version'

module Fintoc
  class Header
    attr_reader :authorization

    attr_accessor :link

    def initialize(authorization)
      @authorization = authorization
      @link = nil
    end

    def params
      { "Authorization": authorization, "User-Agent": user_agent }
    end

    # This attribute getter parses the link headers using some regex 24K magic in the air...
    # Ex.
    # <https://api.fintoc.com/v1/links?page=1>; rel="first", <https://api.fintoc.com/v1/links?page=1>; rel="last"
    # this helps to handle pagination see: https://fintoc.com/docs#paginacion
    # return a hash like { first:"https://api.fintoc.com/v1/links?page=1" }
    #
    # @param link [String]
    # @return [Hash]
    def link
      return if @link.nil?

      @link[0].split(',').reduce({}) { |dict, lk| parse(dict, lk) }
    end

    private

    def user_agent
      "fintoc-ruby/#{Fintoc::VERSION}"
    end

    def parse(dict, link)
      matches = link.strip.match(link_pattern)
      dict[matches[:rel]] = matches[:url]
      dict
    end

    def link_pattern
      '<(?<url>.*)>;\s*rel="(?<rel>.*)"'
    end
  end
end
