require_relative 'constants'

module Fintoc
  module Paginator
    def self.paginate(client, path, params)
      Enumerator.new do |enumerator|
        response = request(client, path, params: params)
        elements = response[:elements]
        elements.each do |element|
          enumerator.yield element
        end

        until response[:next].nil?
          response = request(client, response[:next])
          elements = response[:elements]
          elements.each do |element|
            enumerator.yield element
          end
        end
      end
    end

    def self.request(client, path, params: {})
      response = client.get(path, params)
      headers = parse_link_headers(response.headers[:link])
      next_ = headers && headers[:next]
      elements = response.body
      {
        next: next_,
        elements: elements
      }
    end

    def parse_link_headers(link_header)
      return nil if link_header.nil?

      link_header.split(',').reduce({}) { |memo, elem| parse_link(memo, elem) }
    end

    def parse_link(hash, link)
      matches = link.match(Constants::LINK_HEADER_PATTERN)
      return { **hash } if matches.nil?

      url, rel = matches.captures
      { **hash, rel => url }.transform_keys(&:to_sym)
    end
  end
end
