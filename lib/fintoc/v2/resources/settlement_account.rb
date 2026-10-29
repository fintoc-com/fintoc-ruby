module Fintoc
  module V2
    class SettlementAccount
      attr_reader :id, :object, :account_number, :account_type, :entity_id, :institution_id, :mode

      def initialize(
        id:,
        object:,
        account_number: nil,
        account_type: nil,
        entity_id: nil,
        institution_id: nil,
        mode: nil,
        **
      )
        @id = id
        @object = object
        @account_number = account_number
        @account_type = account_type
        @entity_id = entity_id
        @institution_id = institution_id
        @mode = mode
      end

      def to_s
        "Settlement account (#{@id})"
      end
    end
  end
end
