module Fintoc
  module Movements
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
        "<Fintoc::Movements::Institution #{@name}>"
      end
    end
  end
end
