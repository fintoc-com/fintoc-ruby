require 'money'

module Fintoc
  module V2
    class TransferBatch
      attr_reader :id, :object, :mode, :description, :status, :currency, :transfer_count,
                  :transfer_amount, :succeeded_count, :succeeded_amount, :created_at,
                  :authorized_at, :rejected_at, :expired_at

      def initialize(
        id:,
        object:,
        mode:,
        status:,
        currency:,
        transfer_count:,
        transfer_amount:,
        description: nil,
        succeeded_count: nil,
        succeeded_amount: nil,
        created_at: nil,
        authorized_at: nil,
        rejected_at: nil,
        expired_at: nil,
        client: nil,
        **
      )
        @id = id
        @object = object
        @mode = mode
        @description = description
        @status = status
        @currency = currency
        @transfer_count = transfer_count
        @transfer_amount = transfer_amount
        @succeeded_count = succeeded_count
        @succeeded_amount = succeeded_amount
        @created_at = created_at
        @authorized_at = authorized_at
        @rejected_at = rejected_at
        @expired_at = expired_at
        @client = client
      end

      def to_s
        amount_str = Money.from_cents(@transfer_amount, @currency).format
        "📦 #{amount_str} (#{@id}) - #{@status}"
      end

      def refresh
        fresh_transfer_batch = @client.transfer_batches.get(@id)
        refresh_from_transfer_batch(fresh_transfer_batch)
      end

      def pending_authorization?
        @status == 'pending_authorization'
      end

      def in_progress?
        @status == 'in_progress'
      end

      def rejected?
        @status == 'rejected'
      end

      def expired?
        @status == 'expired'
      end

      def succeeded?
        @status == 'succeeded'
      end

      def partially_succeeded?
        @status == 'partially_succeeded'
      end

      def failed?
        @status == 'failed'
      end

      private

      def refresh_from_transfer_batch(transfer_batch) # rubocop:disable Metrics/MethodLength
        unless transfer_batch.id == @id
          raise ArgumentError, 'Transfer batch must be the same instance'
        end

        @object = transfer_batch.object
        @mode = transfer_batch.mode
        @description = transfer_batch.description
        @status = transfer_batch.status
        @currency = transfer_batch.currency
        @transfer_count = transfer_batch.transfer_count
        @transfer_amount = transfer_batch.transfer_amount
        @succeeded_count = transfer_batch.succeeded_count
        @succeeded_amount = transfer_batch.succeeded_amount
        @created_at = transfer_batch.created_at
        @authorized_at = transfer_batch.authorized_at
        @rejected_at = transfer_batch.rejected_at
        @expired_at = transfer_batch.expired_at

        self
      end
    end
  end
end
