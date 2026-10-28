module Fintoc
  module V1
    class Dispute
      attr_reader :id, :object, :amount, :created_at, :currency, :documentation_upload_deadline,
                  :documents, :mode, :resource_id, :resource_type, :status, :updated_at

      def initialize(
        id:,
        object:,
        amount: nil,
        created_at: nil,
        currency: nil,
        documentation_upload_deadline: nil,
        documents: nil,
        mode: nil,
        resource_id: nil,
        resource_type: nil,
        status: nil,
        updated_at: nil,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @created_at = created_at
        @currency = currency
        @documentation_upload_deadline = documentation_upload_deadline
        @documents = documents
        @mode = mode
        @resource_id = resource_id
        @resource_type = resource_type
        @status = status
        @updated_at = updated_at
      end

      def to_s
        "Dispute (#{@id}) - #{@status}"
      end
    end
  end
end
