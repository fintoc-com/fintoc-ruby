require 'fintoc/utils'

module Fintoc
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
  end
end
