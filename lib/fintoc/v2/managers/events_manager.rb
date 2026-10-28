require 'fintoc/v2/resources/event'

module Fintoc
  module V2
    module Managers
      class EventsManager
        def initialize(client)
          @client = client
        end

        def list(**params)
          @client.get(version: :v2).call('events', **params).map do |data|
            build_event(data)
          end
        end

        def get(event_id)
          data = @client.get(version: :v2).call("events/#{event_id}")
          build_event(data)
        end

        private

        def build_event(data)
          Fintoc::V2::Event.new(**data)
        end
      end
    end
  end
end
