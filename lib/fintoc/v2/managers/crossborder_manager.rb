require 'fintoc/v2/managers/crossborder_beneficiaries_manager'
require 'fintoc/v2/managers/crossborder_quotes_manager'
require 'fintoc/v2/managers/crossborder_transfers_manager'

module Fintoc
  module V2
    module Managers
      class CrossborderManager
        def initialize(client)
          @client = client
        end

        def beneficiaries
          @beneficiaries ||= CrossborderBeneficiariesManager.new(@client)
        end

        def quotes
          @quotes ||= CrossborderQuotesManager.new(@client)
        end

        def transfers
          @transfers ||= CrossborderTransfersManager.new(@client)
        end
      end
    end
  end
end
