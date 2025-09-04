require 'fintoc/base_client'
require 'fintoc/transfers/client/entities_methods'
require 'fintoc/transfers/client/accounts_methods'
require 'fintoc/transfers/client/account_numbers_methods'
require 'fintoc/transfers/client/transfers_methods'
require 'fintoc/transfers/client/simulation_methods'
require 'fintoc/transfers/client/account_verifications_methods'

module Fintoc
  module Transfers
    class Client < BaseClient
      include EntitiesMethods
      include AccountsMethods
      include AccountNumbersMethods
      include TransfersMethods
      include SimulationMethods
      include AccountVerificationsMethods
    end
  end
end
