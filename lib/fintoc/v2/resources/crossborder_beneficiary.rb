module Fintoc
  module V2
    class CrossborderBeneficiary
      attr_reader :id, :object, :mode, :holder_type, :business_name, :first_name, :last_name,
                  :bank_name, :routing_number, :account_last4, :address, :archived_at,
                  :created_at

      def initialize(
        id:,
        object:,
        mode: nil,
        holder_type: nil,
        business_name: nil,
        first_name: nil,
        last_name: nil,
        bank_name: nil,
        routing_number: nil,
        account_last4: nil,
        address: nil,
        archived_at: nil,
        created_at: nil,
        **
      )
        @id = id
        @object = object
        @mode = mode
        @holder_type = holder_type
        @business_name = business_name
        @first_name = first_name
        @last_name = last_name
        @bank_name = bank_name
        @routing_number = routing_number
        @account_last4 = account_last4
        @address = address
        @archived_at = archived_at
        @created_at = created_at
      end

      def archived?
        !@archived_at.nil?
      end

      def to_s
        "Crossborder beneficiary (#{@id}) - #{@bank_name} ****#{@account_last4}"
      end
    end
  end
end
