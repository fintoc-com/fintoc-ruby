require 'date'
require 'fintoc/resources/transfer_account'

module Fintoc
  class Movement
    attr_reader :id, :amount, :currency, :description
    attr_reader :post_date, :transaction_date, :type, :recipient_account
    attr_reader :sender_account, :account

    def initialize(
      id:,
      amount:,
      currency:,
      description:,
      post_date:,
      transaction_date:,
      type:,
      recipient_account:,
      sender_account:,
      comment:,
      **
    )
      @id = id
      @amount = amount
      @currency = currency
      @description = description
      @post_date = Date.iso8601(post_date)
      @transaction_date = Date.iso8601(transaction_date) if transaction_date
      @type = type
      @recipient_account = Fintoc::TransferAccount.new(**recipient_account) if recipient_account
      @sender_account = Fintoc::TransferAccount.new(**sender_account) if sender_account
      @comment = comment
    end

    def ==(other)
      @id = other.id
    end

    alias eql? ==

    def hash
      @id.hash
    end

    def locale_date
      @post_date.strftime('%x')
    end

    def to_s
      "#{@amount} (#{@description} @ #{locale_date})"
    end
  end
end
