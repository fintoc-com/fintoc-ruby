require 'fintoc/v1/resources/link'

module Fintoc
  module V1
    module Managers
      class LinksManager
        def initialize(client)
          @client = client
        end

        def get(link_token)
          data = { **_get_link(link_token), link_token: link_token }
          build_link(data)
        end

        def list
          _get_links.map { |data| build_link(data) }
        end

        def delete(link_id)
          _delete_link(link_id)
        end

        private

        def _get_link(link_token)
          @client.get(version: :v1).call("links/#{link_token}")
        end

        def _get_links
          @client.get(version: :v1).call('links')
        end

        def _delete_link(link_id)
          @client.delete(version: :v1).call("links/#{link_id}")
        end

        def build_link(data)
          param = Utils.pick(data, 'link_token')
          @client.default_params.update(param)
          Fintoc::V1::Link.new(**data, client: @client)
        end
      end
    end
  end
end
