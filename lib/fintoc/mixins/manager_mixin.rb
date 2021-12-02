require_relative '../utils'

module Fintoc
  class ManagerMixin
    @resource = nil
    @methods = []

    class << self
      attr_accessor :resource, :methods
    end

    def initialize(path, client)
      @path = path
      @client = client.extend
      @handlers = {
        update: method(:post_update_handler),
        delete: method(:post_delete_handler)
      }
    end

    def _all(kwargs = {})
      Utils.can_raise_http_error do
        klass = Utils.get_resource_class(self.class.resource)
        klass
      end
    end

    def _get(identifier, kwargs = {})
      Utils.can_raise_http_error do
        klass = Utils.get_resource_class(self.class.resource)
        klass
      end
    end

    def _create(kwargs = {})
      Utils.can_raise_http_error do
        klass = Utils.get_resource_class(self.class.resource)
        klass
      end
    end

    def _update(identifier, kwargs = {})
      Utils.can_raise_http_error do
        klass = Utils.get_resource_class(self.class.resource)
        klass
      end
    end

    def _delete(identifier, kwargs = {})
      Utils.can_raise_http_error do
        klass = Utils.get_resource_class(self.class.resource)
        klass
      end
    end

    def post_all_handler(objects, kwargs = {})
      objects
    end

    def post_get_handler(object, identifier, kwargs = {})
      object
    end

    def post_create_handler(object, kwargs = {})
      object
    end

    def post_update_handler(object, identifier, kwargs = {})
      object
    end

    def post_delete_handler(identifier, kwargs = {})
      identifier
    end
  end
end
