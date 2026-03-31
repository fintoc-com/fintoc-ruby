require 'fintoc/v2/resources/movement'

module Fintoc
  module V2
    module Managers
      class MovementsManager
        def initialize(client, account_id)
          @client = client
          @account_id = account_id
        end

        def list(**params)
          _list_movements(**params).map { |data| build_movement(data) }
        end

        def get(movement_id, **params)
          data = _get_movement(movement_id, **params)
          build_movement(data)
        end

        private

        def _list_movements(**params)
          @client.get(version: :v2).call("accounts/#{@account_id}/movements", **params)
        end

        def _get_movement(movement_id, **params)
          path = "accounts/#{@account_id}/movements/#{movement_id}"
          @client.get(version: :v2).call(path, **params)
        end

        def build_movement(data)
          Fintoc::V2::Movement.new(**data)
        end
      end
    end
  end
end
