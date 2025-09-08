module Fintoc
  module V1
    class Institution
      attr_reader :id, :name, :country

      def initialize(id:, name:, country:, **)
        @id = id
        @name = name
        @country = country
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
