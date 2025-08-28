require 'tabulate'
require 'fintoc/utils'
require 'fintoc/resources/movement'
require 'fintoc/resources/balance'

module Fintoc
  module Movements
    class Account
      include Utils

      attr_reader :id, :name, :holder_name, :currency, :type, :refreshed_at,
                  :official_name, :number, :holder_id, :balance, :movements

      def initialize(
        id:,
        name:,
        official_name:,
        number:,
        holder_id:,
        holder_name:,
        type:,
        currency:,
        refreshed_at: nil,
        balance: nil,
        movements: nil,
        client: nil,
        **
      )
        @id = id
        @name = name
        @official_name = official_name
        @number = number
        @holder_id = holder_id
        @holder_name = holder_name
        @type = type
        @currency = currency
        @refreshed_at = DateTime.iso8601(refreshed_at) if refreshed_at
        @balance = Fintoc::Balance.new(**balance)
        @movements = movements || []
        @client = client
      end

      def update_balance
        @balance = Fintoc::Balance.new(**get_account[:balance])
      end

      def get_movements(**params)
        _get_movements(**params).lazy.map { |movement| Fintoc::Movement.new(**movement) }
      end

      def update_movements(**params)
        @movements += get_movements(**params).to_a
        @movements = @movements.uniq.sort_by(&:post_date)
      end

      def show_movements(rows = 5)
        puts("This account has #{Utils.pluralize(@movements.size, 'movement')}.")

        return unless @movements.any?

        movements =
          @movements
          .to_a
          .slice(0, rows)
          .map.with_index do |mov, index|
            [index + 1, mov.amount, mov.currency, mov.description, mov.locale_date]
          end
        headers = ['#', 'Amount', 'Currency', 'Description', 'Date']
        puts
        puts tabulate(headers, movements, indent: 4, style: 'fancy')
      end

      def to_s
        "💰 #{@holder_name}’s #{@name} #{@balance}"
      end

      private

      def get_account
        @client.get.call("accounts/#{@id}")
      end

      def _get_movements(**params)
        first = @client.get.call("accounts/#{@id}/movements", **params)
        return first if params.empty?

        first + Utils.flatten(@client.fetch_next)
      end
    end
  end
end
