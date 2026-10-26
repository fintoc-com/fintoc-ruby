require 'fintoc/v2/resources/recipient'

module Fintoc
  module V2
    module Managers
      class RecipientsManager
        def initialize(client)
          @client = client
        end

        def create(entity_id:, account_number:, holder_name:, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:).call(
            'recipients', entity_id:, account_number:, holder_name:, **params
          )
          build_recipient(data)
        end

        def get(recipient_id)
          data = @client.get(version: :v2).call("recipients/#{recipient_id}")
          build_recipient(data)
        end

        def list(**params)
          @client.get(version: :v2).call('recipients', **params).map do |data|
            build_recipient(data)
          end
        end

        def update(recipient_id, idempotency_key: nil, **params)
          data = @client.patch(version: :v2, idempotency_key:)
                        .call("recipients/#{recipient_id}", **params)
          build_recipient(data)
        end

        def delete(recipient_id)
          @client.delete(version: :v2).call("recipients/#{recipient_id}")
        end

        private

        def build_recipient(data)
          Fintoc::V2::Recipient.new(**data, client: @client)
        end
      end
    end
  end
end
