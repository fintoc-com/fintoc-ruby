# frozen_string_literal: true

require 'date'
require 'tabulate'
require 'fintoc/utils'
require 'fintoc/resources/account'
require 'fintoc/resources/institution'
require 'tabulate'

module Fintoc
  class Link
    attr_reader :id, :username, :holder_type, :institution
    attr_reader :created_at, :accounts, :link_token
    include Utils
    def initialize(
      id:,
      username:,
      holder_type:,
      institution:,
      created_at:,
      accounts: nil,
      link_token: nil,
      client: nil,
      **
    )
      @id = id
      @username = username
      @holder_type = holder_type
      @institution = Fintoc::Institution.new(**institution)
      @created_at = Date.iso8601(created_at)
      @accounts = accounts.nil? ? [] : accounts.lazy.map { |data| Fintoc::Account.new(**data, client: client) }
      @token = link_token
      @client = client
    end

    def find_all(**kwargs)
      raise 'You must provide *exactly one* account field.' if kwargs.size != 1

      field, value = kwargs.to_a.first
      @accounts.select do |account|
        account.send(field.to_sym) == value
      end
    end

    def find(**kwargs)
      results = find_all(**kwargs)
      results.any? ? results.first : nil
    end

    def show_accounts(rows = 5)
      puts "This links has #{Utils.plurlize(@accounts.size, 'account')}"

      return unless @accounts.any?

      accounts = @accounts.to_a.slice(0, rows)
                          .map.with_index do |acc, index|
                            [index + 1, acc.name, acc.holder_name, account.currency]
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
