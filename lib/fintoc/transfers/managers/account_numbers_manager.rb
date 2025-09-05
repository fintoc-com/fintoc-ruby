require 'fintoc/transfers/resources/account_number'

module Fintoc
  module Transfers
    module Managers
      class AccountNumbersManager
        def initialize(client)
          @client = client
        end

        def create(account_id:, description: nil, metadata: nil, **params)
          data = _create_account_number(account_id:, description:, metadata:, **params)
          build_account_number(data)
        end

        def get(account_number_id)
          data = _get_account_number(account_number_id)
          build_account_number(data)
        end

        def list(**params)
          _list_account_numbers(**params).map { |data| build_account_number(data) }
        end

        def update(account_number_id, **params)
          data = _update_account_number(account_number_id, **params)
          build_account_number(data)
        end

        private

        def _create_account_number(account_id:, description: nil, metadata: nil, **params)
          request_params = { account_id: }
          request_params[:description] = description if description
          request_params[:metadata] = metadata if metadata
          request_params.merge!(params)

          @client.post(version: :v2).call('account_numbers', **request_params)
        end

        def _get_account_number(account_number_id)
          @client.get(version: :v2).call("account_numbers/#{account_number_id}")
        end

        def _list_account_numbers(**params)
          @client.get(version: :v2).call('account_numbers', **params)
        end

        def _update_account_number(account_number_id, **params)
          @client.patch(version: :v2).call("account_numbers/#{account_number_id}", **params)
        end

        def build_account_number(data)
          Fintoc::Transfers::AccountNumber.new(**data, client: @client)
        end
      end
    end
  end
end
