module Fintoc
  module V1
    class Organization
      attr_reader :id, :object, :external_reference, :interested_products, :metadata, :name,
                  :tax_id

      def initialize(
        id:,
        object:,
        external_reference: nil,
        interested_products: nil,
        metadata: nil,
        name: nil,
        tax_id: nil,
        **
      )
        @id = id
        @object = object
        @external_reference = external_reference
        @interested_products = interested_products
        @metadata = metadata
        @name = name
        @tax_id = tax_id
      end

      def to_s
        "Organization (#{@id}) - #{@name}"
      end
    end
  end
end
