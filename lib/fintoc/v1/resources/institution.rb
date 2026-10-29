module Fintoc
  module V1
    class Institution
      attr_reader :id, :name, :country, :type, :products

      def initialize(id:, name:, country:, type: nil, products: nil, **)
        @id = id
        @name = name
        @country = country
        @type = type
        @products = products
      end

      def to_s
        "🏦 #{@name}"
      end

      def inspect
        "<Fintoc::V1::Institution #{@name}>"
      end
    end
  end
end
