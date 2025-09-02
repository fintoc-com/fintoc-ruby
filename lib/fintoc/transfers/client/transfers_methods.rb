require 'fintoc/transfers/resources/transfer'

module Fintoc
  module Transfers
    module TransfersMethods
      def create_transfer(amount:, currency:, account_id:, counterparty:, **params)
        data = _create_transfer(amount:, currency:, account_id:, counterparty:, **params)
        build_transfer(data)
      end

      def get_transfer(transfer_id)
        data = _get_transfer(transfer_id)
        build_transfer(data)
      end

      def list_transfers(**params)
        _list_transfers(**params).map { |data| build_transfer(data) }
      end

      def return_transfer(transfer_id)
        data = _return_transfer(transfer_id)
        build_transfer(data)
      end

      private

      def _create_transfer(amount:, currency:, account_id:, counterparty:, **params)
        post(version: :v2, use_jws: true)
          .call('transfers', amount:, currency:, account_id:, counterparty:, **params)
      end

      def _get_transfer(transfer_id)
        get(version: :v2).call("transfers/#{transfer_id}")
      end

      def _list_transfers(**params)
        get(version: :v2).call('transfers', **params)
      end

      def _return_transfer(transfer_id)
        post(version: :v2, use_jws: true).call('transfers/return', transfer_id:)
      end

      def build_transfer(data)
        Fintoc::Transfers::Transfer.new(**data, client: self)
      end
    end
  end
end
