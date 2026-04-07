module Fintoc
  module V2
    class AccountStatement
      attr_reader :id, :object, :start_date, :end_date, :total_debited_cents,
                  :total_credited_cents, :initial_balance_cents, :final_balance_cents,
                  :download_url, :created_at

      def initialize(
        id:,
        object:,
        start_date:,
        end_date:,
        total_debited_cents:,
        total_credited_cents:,
        initial_balance_cents:,
        final_balance_cents:,
        download_url:,
        created_at:,
        **
      )
        @id = id
        @object = object
        @start_date = start_date
        @end_date = end_date
        @total_debited_cents = total_debited_cents
        @total_credited_cents = total_credited_cents
        @initial_balance_cents = initial_balance_cents
        @final_balance_cents = final_balance_cents
        @download_url = download_url
        @created_at = created_at
      end

      def ==(other)
        @id == other.id
      end

      alias eql? ==

      def hash
        @id.hash
      end

      def to_s
        "AccountStatement(#{@id}) #{@start_date} - #{@end_date}"
      end
    end
  end
end
