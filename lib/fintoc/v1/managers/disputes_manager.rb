require 'fintoc/v1/resources/dispute'
require 'fintoc/v1/resources/dispute_document'

module Fintoc
  module V1
    module Managers
      class DisputesManager
        def initialize(client)
          @client = client
        end

        def list(**params)
          @client.get(version: :v1).call('disputes', **params).map do |data|
            build_dispute(data)
          end
        end

        def get(dispute_id)
          data = @client.get(version: :v1).call("disputes/#{dispute_id}")
          build_dispute(data)
        end

        def submit_for_review(dispute_id, idempotency_key: nil)
          data = @client.post(version: :v1, idempotency_key:)
                        .call("disputes/#{dispute_id}/submit_for_review")
          build_dispute(data)
        end

        def create_document(dispute_id, file:, idempotency_key: nil)
          data = @client.post(version: :v1, idempotency_key:)
                        .call("disputes/#{dispute_id}/documents", form: { file: })
          Fintoc::V1::DisputeDocument.new(**data)
        end

        private

        def build_dispute(data)
          Fintoc::V1::Dispute.new(**data)
        end
      end
    end
  end
end
