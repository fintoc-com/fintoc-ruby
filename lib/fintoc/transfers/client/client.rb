require 'fintoc/base_client'
require 'fintoc/transfers/client/entities_methods'

module Fintoc
  module Transfers
    class Client < BaseClient
      include EntitiesMethods
    end
  end
end
