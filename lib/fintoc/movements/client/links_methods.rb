require 'fintoc/movements/resources/link'

module Fintoc
  module Movements
    module LinksMethods
      def get_link(link_token)
        data = { **_get_link(link_token), link_token: link_token }
        build_link(data)
      end

      def get_links
        _get_links.map { |data| build_link(data) }
      end

      def delete_link(link_id)
        delete.call("links/#{link_id}")
      end

      def get_account(link_token, account_id)
        get_link(link_token).find(id: account_id)
      end

      private

      def _get_link(link_token)
        get.call("links/#{link_token}")
      end

      def _get_links
        get.call('links')
      end

      def build_link(data)
        param = Utils.pick(data, 'link_token')
        @default_params.update(param)
        Fintoc::Movements::Link.new(**data, client: self)
      end
    end
  end
end
