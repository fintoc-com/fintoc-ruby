require 'date'
require 'faraday'

module Fintoc
  module Utils
    def self.snake_to_pascal(snake_string)
      snake_string.split('_').map(&:capitalize).join
    end

    def self.singularize(string)
      string.chomp('s')
    end

    def self.set_attribute(object, key, value)
      raise NameError.new if object.methods.include?(key.to_sym)

      object.instance_variable_set("@#{key}".to_sym, value)
      object.class.class_eval { attr_reader key.to_sym }
    end

    def self.iso_datetime?(string)
      begin
        DateTime.iso8601(string)
        true
      rescue ArgumentError
        false
      end
    end

    def self.get_resource_class(snake_resource_name, value: {})
      if value.instance_of?(Hash)
        begin
          require_relative "resources/#{snake_resource_name}"
          return const_get(snake_to_pascal(snake_resource_name))
        rescue LoadError, NameError
          require_relative 'resources/generic_fintoc_resource'
          return const_get('GenericFintocResource')
        end
      end

      return DateTime if value.instance_of?(String) && iso_datetime?(value)

      value.class
    end

    def self.get_error_class(snake_error_name)
      require_relative 'errors'
      begin
        const_get(snake_to_pascal(snake_error_name))
      rescue LoadError, NameError
        const_get('FintocError')
      end
    end

    def self.can_raise_http_error(&block)
      begin
        block.call
      rescue Faraday::Error => e
        error_data = e.response_body
        error = get_error_class(error_data[:error][:type])
        raise error.new(error_data[:error])
      end
    end

    def self.serialize(object)
      return object.serialize if object.respond_to?(:serialize)

      return object.iso8601 if object.instance_of?(DateTime)

      object
    end

    def self.objetize(klass, client, data, handlers: {}, methods: [], path: nil)
      return nil if data.nil?

      return data if [TrueClass, FalseClass].include?(klass)

      return klass.new(data) if [String, Integer, Hash].include?(klass)

      return klass.iso8601(data) if klass == DateTime

      klass.call(client, handlers, methods, path, data)
    end

    def self.objetize_enumerator(enumerator, klass, client, handlers: {}, methods: [], path: nil)
      Enumerator.new do |internal_enumerator|
        enumerator.each do |element|
          internal_enumerator.yield objetize(klass, client, element, handlers, methods, path)
        end
      end
    end
  end
end
