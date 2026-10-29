module Fintoc
  module V1
    class RefreshIntent
      attr_reader :id, :object, :created_at, :new_movements, :public_error, :refreshed_object,
                  :refreshed_object_id, :requires_mfa, :status, :type

      def initialize(
        id:,
        object:,
        created_at: nil,
        new_movements: nil,
        public_error: nil,
        refreshed_object: nil,
        refreshed_object_id: nil,
        requires_mfa: nil,
        status: nil,
        type: nil,
        **
      )
        @id = id
        @object = object
        @created_at = created_at
        @new_movements = new_movements
        @public_error = public_error
        @refreshed_object = refreshed_object
        @refreshed_object_id = refreshed_object_id
        @requires_mfa = requires_mfa
        @status = status
        @type = type
      end

      def to_s
        "Refresh intent (#{@id}) - #{@status}"
      end
    end
  end
end
