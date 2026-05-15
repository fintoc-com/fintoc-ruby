module Fintoc
  module V1
    class WebhookEndpoint
      attr_reader :id, :object, :url, :mode, :enabled_events, :secret, :disabled, :created_at

      def initialize(
        id:,
        object:,
        url:,
        mode:,
        enabled_events:,
        secret:,
        disabled:,
        created_at:,
        client: nil,
        **
      )
        @id = id
        @object = object
        @url = url
        @mode = mode
        @enabled_events = enabled_events
        @secret = secret
        @disabled = disabled
        @created_at = created_at
        @client = client
      end

      def to_s
        "🔔 #{@url} (#{@id})"
      end

      def disabled?
        @disabled
      end
    end
  end
end
