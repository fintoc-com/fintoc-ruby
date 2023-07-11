require 'date'
require 'tabulate'
require 'fintoc/utils'
require 'tabulate'

module Fintoc
  class Link < Resource

    has_many :accounts, class_name: Account.to_s

    belongs_to :institution, class_name: Institution.to_s

    include Utils

    def show_accounts(rows = 5)
      puts "This links has #{Utils.pluralize(@accounts.size, 'account')}"
      return unless @accounts.any?

      accounts = @accounts
                  .to_a
                  .slice(0, rows)
                  .map.with_index do |acc, index|
                    [index + 1, acc.name, acc.holder_name, acc.currency]
                  end
      headers = ['#', 'Name', 'Holder', 'Currency']
      puts
      puts tabulate(headers, accounts, indent: 4, style: 'fancy')
    end

    def update_accounts
      @accounts.each do |account|
        account.update_balance
        account.update_movements
      end
    end

    def delete
      @client.delete_link(@id)
    end

    def to_s
      "<#{@username}@#{@institution.name}> 🔗 <Fintoc>"
    end
  end
end
