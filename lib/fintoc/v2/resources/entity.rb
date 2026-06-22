require 'fintoc/v2/managers/onboardings_manager'

module Fintoc
  module V2
    class Entity
      attr_reader :object, :mode, :id, :holder_name, :holder_id, :is_root, :status, :country_code

      def initialize(
        object:,
        mode:,
        id:,
        holder_name:,
        holder_id:,
        is_root:,
        status: nil,
        country_code: nil,
        client: nil,
        **
      )
        @object = object
        @mode = mode
        @id = id
        @holder_name = holder_name
        @holder_id = holder_id
        @is_root = is_root
        @status = status
        @country_code = country_code
        @client = client
      end

      def to_s
        "🏢 #{@holder_name} (#{@id})"
      end

      def refresh
        fresh_entity = @client.entities.get(@id)
        refresh_from_entity(fresh_entity)
      end

      def onboardings
        @onboardings ||= Managers::OnboardingsManager.new(@client, @id)
      end

      private

      def refresh_from_entity(entity)
        unless entity.id == @id
          raise ArgumentError, 'Entity must be the same instance'
        end

        @object = entity.object
        @mode = entity.mode
        @holder_name = entity.holder_name
        @holder_id = entity.holder_id
        @is_root = entity.is_root
        @status = entity.status
        @country_code = entity.country_code

        self
      end
    end
  end
end
