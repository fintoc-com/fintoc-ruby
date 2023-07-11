require 'tabulate'
require 'fintoc/utils'
require 'fintoc/resources/movement'
require 'fintoc/resources/balance'

module Fintoc
  class Account < Resource
    include Utils

    belongs_to :balance, class_name: Fintoc::Balance.to_s
    has_many :movements, class_name: Fintoc::Movement.to_s

    def show_movements(rows = 5)
      puts("This account has #{Utils.pluralize(movements.size, 'movement')}.")

      return unless movements.any?

      movements = movements.to_a.slice(0, rows)
                            .map.with_index do |mov, index|
                              [index + 1, mov.amount, mov.currency, mov.description, mov.locale_date]
                            end
      headers = ['#', 'Amount', 'Currency', 'Description', 'Date']
      puts
      puts tabulate(headers, movements, indent: 4, style: 'fancy')
    end

    def to_s
      "💰 #{holder_name}’s #{@name} #{@balance}"
    end
  end
end
