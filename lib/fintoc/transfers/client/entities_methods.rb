require 'fintoc/transfers/resources/entity'

module Fintoc
  module Transfers
    module EntitiesMethods
      def get_entity(entity_id)
        data = _get_entity(entity_id)
        build_entity(data)
      end

      def get_entities(**params)
        _get_entities(**params).map { |data| build_entity(data) }
      end

      private

      def _get_entity(entity_id)
        get(version: :v2).call("entities/#{entity_id}")
      end

      def _get_entities(**params)
        response = get(version: :v2).call('entities', **params)
        # Handle both single entity and list responses
        response.is_a?(Array) ? response : [response]
      end

      def build_entity(data)
        Fintoc::Transfers::Entity.new(**data, client: self)
      end
    end
  end
end
