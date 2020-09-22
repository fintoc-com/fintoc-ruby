module Fintoc
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
      "<Institution #{@name}>"
    end
  end
end