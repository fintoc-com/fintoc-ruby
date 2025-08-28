require 'fintoc/base_client'
require 'fintoc/movements/client/links_methods'

module Fintoc
  module Movements
    class Client < BaseClient
      include LinksMethods
    end
  end
end
