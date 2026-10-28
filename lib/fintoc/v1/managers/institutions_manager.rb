require 'fintoc/v1/resources/institution'

module Fintoc
  module V1
    module Managers
      class InstitutionsManager
        def initialize(client)
          @client = client
        end

        def list(**params)
          @client.get(version: :v1).call('institutions', **params).map do |data|
            Fintoc::V1::Institution.new(**data)
          end
        end
      end
    end
  end
end
