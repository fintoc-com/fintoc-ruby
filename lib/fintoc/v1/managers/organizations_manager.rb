require 'fintoc/v1/resources/organization'

module Fintoc
  module V1
    module Managers
      class OrganizationsManager
        def initialize(client)
          @client = client
        end

        def create(name:, tax_id:, founder_email:, products:, **params)
          data = @client.post(version: :v1)
                        .call('organizations', name:, tax_id:, founder_email:, products:, **params)
          build_organization(data)
        end

        def update(organization_id, founder_email:, previous_founder_email:)
          data = @client.patch(version: :v1)
                        .call("organizations/#{organization_id}", founder_email:,
                                                                  previous_founder_email:)
          build_organization(data)
        end

        private

        def build_organization(data)
          Fintoc::V1::Organization.new(**data)
        end
      end
    end
  end
end
