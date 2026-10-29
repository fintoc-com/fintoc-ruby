module Fintoc
  module V1
    class TaxReturn
      attr_reader :id, :object, :currency, :document_number, :fiscal_year, :institution_id,
                  :institution_tax_return, :taxpayer

      def initialize(
        id:,
        object:,
        currency: nil,
        document_number: nil,
        fiscal_year: nil,
        institution_id: nil,
        institution_tax_return: nil,
        taxpayer: nil,
        **
      )
        @id = id
        @object = object
        @currency = currency
        @document_number = document_number
        @fiscal_year = fiscal_year
        @institution_id = institution_id
        @institution_tax_return = institution_tax_return
        @taxpayer = taxpayer
      end

      def to_s
        "Tax return (#{@id})"
      end
    end
  end
end
