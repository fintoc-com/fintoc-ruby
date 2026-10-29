module Fintoc
  module V1
    class DisputeDocument
      attr_reader :id, :object, :content_type, :created_at, :dispute_id, :filename, :size

      def initialize(
        id:,
        object:,
        content_type: nil,
        created_at: nil,
        dispute_id: nil,
        filename: nil,
        size: nil,
        **
      )
        @id = id
        @object = object
        @content_type = content_type
        @created_at = created_at
        @dispute_id = dispute_id
        @filename = filename
        @size = size
      end

      def to_s
        "Dispute document (#{@id})"
      end
    end
  end
end
