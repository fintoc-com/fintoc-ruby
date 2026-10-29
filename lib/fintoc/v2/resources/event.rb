module Fintoc
  module V2
    class Event
      attr_reader :id, :object, :created_at, :data, :mode, :type

      def initialize(
        id:,
        object:,
        created_at: nil,
        data: nil,
        mode: nil,
        type: nil,
        **
      )
        @id = id
        @object = object
        @created_at = created_at
        @data = data
        @mode = mode
        @type = type
      end

      def to_s
        "Event (#{@id})"
      end
    end
  end
end
