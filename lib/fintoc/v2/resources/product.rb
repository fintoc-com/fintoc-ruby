module Fintoc
  module V2
    class Product
      attr_reader :id, :object, :created_at, :description, :image_url, :metadata, :mode, :name

      def initialize(
        id:,
        object:,
        created_at: nil,
        description: nil,
        image_url: nil,
        metadata: nil,
        mode: nil,
        name: nil,
        **
      )
        @id = id
        @object = object
        @created_at = created_at
        @description = description
        @image_url = image_url
        @metadata = metadata
        @mode = mode
        @name = name
      end

      def to_s
        "Product (#{@id})"
      end
    end
  end
end
