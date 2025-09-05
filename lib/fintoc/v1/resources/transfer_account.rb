require 'fintoc/v1/resources/institution'

module Fintoc
  module V1
    class TransferAccount
      attr_reader :holder_id, :holder_name, :number, :institution

      def initialize(holder_id:, holder_name:, number:, institution:, **)
        @holder_id = holder_id
        @holder_name = holder_name
        @number = number
        @institution = institution && Fintoc::V1::Institution.new(**institution)
      end

      def id
        object_id
      end

      def to_s
        @holder_id.to_s
      end
    end
  end
end
