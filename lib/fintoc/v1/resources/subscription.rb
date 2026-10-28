module Fintoc
  module V1
    class Subscription
      attr_reader :id, :object, :account, :created_at, :mode, :reference_id, :status

      def initialize(
        id:,
        object:,
        account: nil,
        created_at: nil,
        mode: nil,
        reference_id: nil,
        status: nil,
        **
      )
        @id = id
        @object = object
        @account = account
        @created_at = created_at
        @mode = mode
        @reference_id = reference_id
        @status = status
      end

      def to_s
        "Subscription (#{@id}) - #{@status}"
      end
    end
  end
end
