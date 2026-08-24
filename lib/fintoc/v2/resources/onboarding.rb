module Fintoc
  module V2
    class Onboarding
      attr_reader :object, :id, :entity_id, :type, :status, :source, :submitted_at,
                  :reviewed_at, :submittable, :data, :legal_representatives, :shareholders,
                  :documents

      def initialize(
        object:,
        id:,
        entity_id: nil,
        type: nil,
        status: nil,
        source: nil,
        submitted_at: nil,
        reviewed_at: nil,
        submittable: nil,
        data: nil,
        legal_representatives: nil,
        shareholders: nil,
        documents: nil,
        client: nil,
        **
      )
        @object = object
        @id = id
        @entity_id = entity_id
        @type = type
        @status = status
        @source = source
        @submitted_at = submitted_at
        @reviewed_at = reviewed_at
        @submittable = submittable
        @data = data
        @legal_representatives = legal_representatives
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
