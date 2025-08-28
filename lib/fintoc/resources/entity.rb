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

    def refresh
      entity_data = @client.get_entity(@id)
      initialize(**entity_data.instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete('@').to_sym] = entity_data.instance_variable_get(var)
      end)
    end
  end
end
