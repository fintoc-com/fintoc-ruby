module Fintoc
  module V2
    class SetupIntent
      attr_reader :id, :object, :error_reason, :status

      def initialize(
        id:,
        object:,
        error_reason: nil,
        status: nil,
        **
      )
        @id = id
        @object = object
        @error_reason = error_reason
        @status = status
      end

      def to_s
        "Setup intent (#{@id}) - #{@status}"
      end
    end
  end
end
