require 'fintoc/v2/resources/entity'

module Fintoc
  module V2
    module Managers
      class EntitiesManager
        def initialize(client)
          @client = client
        end

        def get(entity_id)
          data = _get_entity(entity_id)
          build_entity(data)
        end

        def list(**params)
          _list_entities(**params).map { |data| build_entity(data) }
        end

        private

        def _get_entity(entity_id)
          @client.get(version: :v2).call("entities/#{entity_id}")
        end

        def _list_entities(**params)
          @client.get(version: :v2).call('entities', **params)
        end

        def build_entity(data)
          Fintoc::V2::Entity.new(**data, client: @client)
        end
      end
    end
  end
end
