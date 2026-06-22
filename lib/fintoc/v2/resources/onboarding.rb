module Fintoc
  module V2
    class Onboarding
      attr_reader :object, :id, :entity_id, :status, :source, :submitted_at, :reviewed_at,
                  :submittable, :data, :shareholders, :documents

      def initialize(
        object:,
        id:,
        entity_id: nil,
        status: nil,
        source: nil,
        submitted_at: nil,
        reviewed_at: nil,
        submittable: nil,
        data: nil,
        shareholders: nil,
        documents: nil,
        client: nil,
        **
      )
        @object = object
        @id = id
        @entity_id = entity_id
        @status = status
        @source = source
        @submitted_at = submitted_at
        @reviewed_at = reviewed_at
        @submittable = submittable
        @data = data
        @shareholders = shareholders
        @documents = documents
        @client = client
      end

      def to_s
        "📋 Onboarding #{@id} (#{@status})"
      end
    end
  end
end
