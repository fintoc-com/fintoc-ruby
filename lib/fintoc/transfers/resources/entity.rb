require 'fintoc/utils'

module Fintoc
  module Transfers
    class Entity
      include Utils

      attr_reader :object, :mode, :id, :holder_name, :holder_id, :is_root

      def initialize(
        object:,
        mode:,
        id:,
        holder_name:,
        holder_id:,
        is_root:,
        client: nil,
        **
      )
        @object = object
        @mode = mode
        @id = id
        @holder_name = holder_name
        @holder_id = holder_id
        @is_root = is_root
        @client = client
      end

      def to_s
        "🏢 #{@holder_name} (#{@id})"
      end

      def refresh
        fresh_entity = @client.get_entity(@id)
        refresh_from_entity(fresh_entity)
      end

      private

      def refresh_from_entity(entity)
        raise 'Entity must be the same instance' unless entity.id == @id

        @object = entity.object
        @mode = entity.mode
        @holder_name = entity.holder_name
        @holder_id = entity.holder_id
        @is_root = entity.is_root

        self
      end
    end
  end
end
