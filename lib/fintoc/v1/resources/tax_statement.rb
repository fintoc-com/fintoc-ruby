module Fintoc
  module V1
    class TaxStatement
      attr_reader :id, :object, :currency, :document_number, :fiscal_year, :institution_id,
                  :institution_tax_statement, :interval_unit, :period, :status, :taxpayer

      def initialize(
        id:,
        object:,
        currency: nil,
        document_number: nil,
        fiscal_year: nil,
        institution_id: nil,
        institution_tax_statement: nil,
        interval_unit: nil,
        period: nil,
        status: nil,
        taxpayer: nil,
        **
      )
        @id = id
        @object = object
        @currency = currency
        @document_number = document_number
        @fiscal_year = fiscal_year
        @institution_id = institution_id
        @institution_tax_statement = institution_tax_statement
        @interval_unit = interval_unit
        @period = period
        @status = status
        @taxpayer = taxpayer
      end

      def to_s
        "Tax statement (#{@id}) - #{@status}"
      end
    end
  end
end
