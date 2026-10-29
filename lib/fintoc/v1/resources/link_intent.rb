module Fintoc
  module V1
    class LinkIntent
      attr_reader :id, :object, :country, :created_at, :exchange_token, :exchange_token_expires_at,
                  :holder_type, :mode, :product, :status, :widget_token

      def initialize(
        id:,
        object:,
        country: nil,
        created_at: nil,
        exchange_token: nil,
        exchange_token_expires_at: nil,
        holder_type: nil,
        mode: nil,
        product: nil,
        status: nil,
        widget_token: nil,
        **
      )
        @id = id
        @object = object
        @country = country
        @created_at = created_at
        @exchange_token = exchange_token
        @exchange_token_expires_at = exchange_token_expires_at
        @holder_type = holder_type
        @mode = mode
        @product = product
        @status = status
        @widget_token = widget_token
      end

      def to_s
        "Link intent (#{@id}) - #{@status}"
      end
    end
  end
end
