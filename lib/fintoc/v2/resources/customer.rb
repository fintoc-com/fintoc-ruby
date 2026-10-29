module Fintoc
  module V2
    class Customer
      attr_reader :id, :object, :address, :created_at, :email, :metadata, :mode, :name, :phone,
                  :tax_id

      def initialize(
        id:,
        object:,
        address: nil,
        created_at: nil,
        email: nil,
        metadata: nil,
        mode: nil,
        name: nil,
        phone: nil,
        tax_id: nil,
        **
      )
        @id = id
        @object = object
        @address = address
        @created_at = created_at
        @email = email
        @metadata = metadata
        @mode = mode
        @name = name
        @phone = phone
        @tax_id = tax_id
      end

      def to_s
        "Customer (#{@id})"
      end
    end
  end
end
