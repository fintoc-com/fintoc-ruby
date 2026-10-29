require 'fintoc/v1/resources/movement'

module Fintoc
  module V1
    module Managers
      class MovementsManager
        def initialize(client)
          @client = client
        end

        def list(account_id, link_token:, **params)
          @client.get(version: :v1)
                 .call("accounts/#{account_id}/movements", link_token:, **params)
                 .map { |data| build_movement(data) }
        end

        def get(account_id, movement_id, link_token:)
          data = @client.get(version: :v1)
                        .call("accounts/#{account_id}/movements/#{movement_id}", link_token:)
          build_movement(data)
        end

        private

        def build_movement(data)
          Fintoc::V1::Movement.new(**data, client: @client)
        end
      end
    end
  end
end
