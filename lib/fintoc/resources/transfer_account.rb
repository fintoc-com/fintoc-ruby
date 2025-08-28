require 'fintoc/resources/movements/institution'

module Fintoc
  class TransferAccount
    attr_reader :holder_id, :holder_name, :number, :institution

    def initialize(holder_id:, holder_name:, number:, institution:, **)
      @holder_id = holder_id
      @holder_name = holder_name
      @number = number
      @institution = institution && Fintoc::Movements::Institution.new(**institution)
    end

    def id
      object_id
    end

    def to_s
      @holder_id.to_s
    end
  end
end
