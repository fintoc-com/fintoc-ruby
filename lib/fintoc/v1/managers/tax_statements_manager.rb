require 'fintoc/v1/resources/tax_statement'

module Fintoc
  module V1
    module Managers
      class TaxStatementsManager
        def initialize(client)
          @client = client
        end

        def list(link_token:, **params)
          @client.get(version: :v1).call('tax_statements', link_token:, **params).map do |data|
            build_tax_statement(data)
          end
        end

        def get(tax_statement_id, link_token:)
          data = @client.get(version: :v1).call("tax_statements/#{tax_statement_id}", link_token:)
          build_tax_statement(data)
        end

        private

        def build_tax_statement(data)
          Fintoc::V1::TaxStatement.new(**data)
        end
      end
    end
  end
end
