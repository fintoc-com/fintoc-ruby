require 'fintoc/v2/resources/account_number'

module Fintoc
  module V2
    module Managers
      class AccountNumbersManager
        def initialize(client)
          @client = client
        end

        def create(account_id:, description: nil, metadata: nil, idempotency_key: nil, **params)
          data = _create_account_number(
            account_id:, description:, metadata:, idempotency_key:, **params
          )
          build_account_number(data)
        end

        def get(account_number_id)
          data = _get_account_number(account_number_id)
          build_account_number(data)
        end

        def list(**params)
          _list_account_numbers(**params).map { |data| build_account_number(data) }
        end

        def update(account_number_id, idempotency_key: nil, **params)
          data = _update_account_number(account_number_id, idempotency_key:, **params)
          build_account_number(data)
        end

        def delete(account_number_id)
          _delete_account_number(account_number_id)
        end

        private

        def _create_account_number(
          account_id:, description: nil, metadata: nil, idempotency_key: nil, **params
        )
          request_params = { account_id: }
          request_params[:description] = description if description
          request_params[:metadata] = metadata if metadata
          request_params.merge!(params)

          @client.post(version: :v2, idempotency_key:).call('account_numbers', **request_params)
        end

        def _get_account_number(account_number_id)
          @client.get(version: :v2).call("account_numbers/#{account_number_id}")
        end

        def _list_account_numbers(**params)
          @client.get(version: :v2).call('account_numbers', **params)
        end

        def _update_account_number(account_number_id, idempotency_key: nil, **params)
          @client.patch(version: :v2, idempotency_key:)
                 .call("account_numbers/#{account_number_id}", **params)
        end

        def _delete_account_number(account_number_id)
          @client.delete(version: :v2).call("account_numbers/#{account_number_id}")
        end

        def build_account_number(data)
          Fintoc::V2::AccountNumber.new(**data, client: @client)
        end
      end
    end
  end
end
