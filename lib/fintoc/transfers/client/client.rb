require 'fintoc/base_client'
require 'fintoc/transfers/client/entities_methods'
require 'fintoc/transfers/client/accounts_methods'
require 'fintoc/transfers/client/account_numbers_methods'

module Fintoc
  module Transfers
    class Client < BaseClient
      include EntitiesMethods
      include AccountsMethods
      include AccountNumbersMethods
    end
  end
end
