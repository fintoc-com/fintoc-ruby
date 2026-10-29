module Fintoc
  module V1
    class Invoice
      attr_reader :id, :object, :currency, :date, :institution_id, :institution_invoice,
                  :issue_type, :issuer, :net_amount, :number, :receiver, :tax_period, :total_amount

      def initialize(
        id:,
        object:,
        currency: nil,
        date: nil,
        institution_id: nil,
        institution_invoice: nil,
        issue_type: nil,
        issuer: nil,
        net_amount: nil,
        number: nil,
        receiver: nil,
        tax_period: nil,
        total_amount: nil,
        **
      )
        @id = id
        @object = object
        @currency = currency
        @date = date
        @institution_id = institution_id
        @institution_invoice = institution_invoice
        @issue_type = issue_type
        @issuer = issuer
        @net_amount = net_amount
        @number = number
        @receiver = receiver
        @tax_period = tax_period
        @total_amount = total_amount
      end

      def to_s
        "Invoice (#{@id})"
      end
    end
  end
end
