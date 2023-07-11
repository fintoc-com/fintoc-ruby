module Fintoc
  module APIOperations
    module Request
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def request(method, url, params={})
          check_api_key!
          raise "Not supported method" unless %i[get delete].include(method)
          api_client.send(method).call(url, **params)
        end

        def fetch_next(method, url, params={})
          first = request(method, url, params)
          return first if params.empty?

          first + Utils.flatten(api_client.fetch_next)
        end

        def api_client
          @api_client = Client.new(Fintoc.api_key)
        end

        protected def check_api_key!
          return if Fintoc.api_key

          raise AuthenticationError, <<~MSG
              No API key provided.
              Set your API key using 'Fitoc.api_key = <API-KEY>'
            MSG
        end
      end

      protected def request(method, url, params = {})
        self.class.request(method, url, params)
      end

      protected def fetch_next(method, url, params = {})
        self.class.fetch_next(method, url, params)
      end
    end
  end
end
