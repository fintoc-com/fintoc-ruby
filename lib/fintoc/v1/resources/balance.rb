# frozen_string_literal: true

module Fintoc
  module V1
    class Balance
      attr_reader :available, :current, :limit

      def initialize(available:, current:, limit:)
        @available = available
        @current = current
        @limit = limit
      end

      def id
        object_id
      end

      def to_s
        "#{@available} (#{@current})"
      end

      def inspect
        "<Fintoc::V1::Balance #{@available} (#{@current})>"
      end
    end
  end
end
