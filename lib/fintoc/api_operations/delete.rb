module Fintoc
  module APIOperations
    module Delete
      def delete
        request(:delete, resource_url)
      end
    end
  end
end
