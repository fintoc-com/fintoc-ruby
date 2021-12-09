require_relative '../utils'

module Fintoc
  class ResourceMixin
    @mappings = {}
    @resource_identifier = {}

    class << self
      attr_accessor :mappings, :resource_identifier
    end

    def initialize(client, handlers, methods, path, kwargs)
      @client = client
      @handlers = handlers
      @methods = methods
      @path = path
      @attributes = []

      kwargs.each do |key, value|
        begin
          resource = self.class.mappings.fetch(key, key)
          if value.instance_of?(Array)
            resource = Utils.singularize(resource)
            element = value.empty? ? {} : value[0]
            klass = Utils.get_resource_class(resource, element)
            Utils.set_attribute(self, key, value.map { |x| Utils.objetize(klass, client, x) })
          else
            klass = Utils.get_resource_class(resource, value)
            Utils.set_attribute(self, key, Utils.objetize(klass, client, value))
          end
          @attributes << key
        rescue NameError # rubocop:disable Lint/SuppressedException
        end
      end
    end

    def serialize
      serialized = {}
      @attributes.each do |key|
        element = (
          send(key).instance_of?(Array) ?
            send(key).map { |x| Utils.serialize(x) } :
            Utils.serialize(send(key))
        )
        serialized = { **serialized, key => element }
      end
      serialized
    end
  end
end
