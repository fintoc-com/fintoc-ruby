require 'fintoc/v2/resources/setup_intent'

module Fintoc
  module V2
    module Managers
      class SetupIntentsManager
        def initialize(client)
          @client = client
        end

        def get(setup_intent_id)
          data = @client.get(version: :v2).call("setup_intents/#{setup_intent_id}")
          build_setup_intent(data)
        end

        private

        def build_setup_intent(data)
          Fintoc::V2::SetupIntent.new(**data)
        end
      end
    end
  end
end
