require 'faraday'

module Fintoc
  def self.snake_to_pascal(snake_string)
    snake_string.split('_').map(&:capitalize).join
  end

  def self.singularize(string)
    string.chomp('s')
  end

  def self.iso_datetime?(string)
    begin
      Date.iso8601(string)
      true
    rescue ArgumentError
      false
    end
  end

  def self.get_resource_class_constructor(snake_resource_name, value: {})
    if value.instance_of?(Hash)
      begin
        require_relative "resources/#{snake_resource_name}"
        return const_get(snake_to_pascal(snake_resource_name)).method(:new)
      rescue LoadError, NameError
        require_relative 'resources/generic_fintoc_resource'
        return const_get('GenericFintocResource').method(:new)
      end
    end

    return Date.method(:iso8601) if value.instance_of?(String) && iso_datetime?(value)

    value.class.method(:new)
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
end
