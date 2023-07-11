module Fintoc
  class Resource
    include Fintoc::APIOperations::Request
    include Fintoc::APIOperations::Delete

    class << self
      attr_reader :resource_url

      def class_name
        name.split("::")[-1]
      end

      def resource_url
        if self == Resource
          raise NotImplementedError, <<~MSG
            Fintoc::Resource is an abstract class. You should perform actions
            on its subsclasses (Link, Account, Movement, etc)
          MSG
        end

        resource_url || "#{class_name.downcase}"
      end

      def find(id)
        response = request(:get, "#{resource_url}/#{id}")
        new(response)
      end

      def all(params = {})
        response = request(:get, resource_url, params)
        response.map {|data| new(data)}
      end

      def belongs_to(resource_name, args={})
        class_name = args[:class_name]
        unless resource_name && class_name
          raise <<~MSG
            You must specify the resource name and its class name
            for example has_many :accounts, class_name: 'Account'
          MSG
        end
        class_name = "::Fintoc::#{class_name}" unless class_name.include?("Fintoc")
        if resource == :method
        define_method(resource_name) do |params = {}|
          data = request(:get, resource_url, params)
          Object.const_get(class_name).new(**data)
        end
      end

      def has_many(resource_name, args={})
        class_name = args[:class_name]
        unless resource_name && class_name
          raise <<~MSG
            You must specify the resource name and its class name
            for example has_many :accounts, class_name: 'Account'
          MSG
        end

        # Add namespace to class_name
        class_name = "::Fintoc::#{class_name}" unless class_name.include?("Fintoc")
        define_method(resource_name) do |params = {}|
                                    #link/accounts
          fetch_next(
            :get,
            "#{resource_url}/#{resource_name}", params
          ).lazy.map do |data|
            Object.const_get(class_name).new(**data)
          end
        end
      end
    end

    def initialize(data={})
      @data = @unsaved_data = {}
      initialize_from_data(data)
    end

    def initilize_from_data(data)
      klass = self.class

      @data = data

      data.each_key do |k|
        klass.define_method(k) { @data[k]}

        klass.define_method(:"#{k}=") do |value|
          @data[k] = @unsaved_data[k] = value
        end

        next unless[FalseClass, TrueClass].include?(
          @data[k]
        )

        klass.define_method(:"#{k}?") do
          @data[k]
        end
      end
      self
    end

    def resource_url
      "#{self.resource_url}/#{id}"
    end
  end
end
