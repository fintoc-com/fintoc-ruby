module Fintoc
  module V1
    class WebhookEndpoint
      attr_reader :id, :object, :url, :mode, :enabled_events, :secret, :status, :description,
                  :name, :created_at

      def initialize(
        id:,
        object:,
        url:,
        mode:,
        enabled_events:,
        secret:,
        status:,
        created_at:,
        description: nil,
        name: nil,
        client: nil,
        **
      )
        @id = id
        @object = object
        @url = url
        @mode = mode
        @enabled_events = enabled_events
        @secret = secret
        @status = status
        @description = description
        @name = name
        @created_at = created_at
        @client = client
      end

      def to_s
        "🔔 #{@url} (#{@id})"
      end

      def disabled?
        @status == 'disabled'
      end
      alias disabled disabled?
    end
  end
end
