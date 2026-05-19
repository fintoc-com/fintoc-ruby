require 'fintoc/v1/resources/webhook_endpoint'

module Fintoc
  module V1
    module Managers
      class WebhookEndpointsManager
        def initialize(client)
          @client = client
        end

        def create(url:, enabled_events:, idempotency_key: nil, **params)
          data = _create_webhook_endpoint(
            url:, enabled_events:, idempotency_key:, **params
          )
          build_webhook_endpoint(data)
        end

        def get(webhook_endpoint_id)
          data = _get_webhook_endpoint(webhook_endpoint_id)
          build_webhook_endpoint(data)
        end

        def list(**params)
          _list_webhook_endpoints(**params).map { |data| build_webhook_endpoint(data) }
        end

        def update(webhook_endpoint_id, idempotency_key: nil, **params)
          data = _update_webhook_endpoint(webhook_endpoint_id, idempotency_key:, **params)
          build_webhook_endpoint(data)
        end

        def delete(webhook_endpoint_id)
          _delete_webhook_endpoint(webhook_endpoint_id)
        end

        def test(webhook_endpoint_id, type:)
          data = _test_webhook_endpoint(webhook_endpoint_id, type:)
          build_webhook_endpoint(data)
        end

        private

        def _create_webhook_endpoint(url:, enabled_events:, idempotency_key: nil, **params)
          request_params = { url:, enabled_events: }
          request_params.merge!(params)

          @client.post(version: :v1, idempotency_key:).call('webhook_endpoints', **request_params)
        end

        def _get_webhook_endpoint(webhook_endpoint_id)
          @client.get(version: :v1).call("webhook_endpoints/#{webhook_endpoint_id}")
        end

        def _list_webhook_endpoints(**params)
          @client.get(version: :v1).call('webhook_endpoints', **params)
        end

        def _update_webhook_endpoint(webhook_endpoint_id, idempotency_key: nil, **params)
          @client.patch(version: :v1, idempotency_key:)
                 .call("webhook_endpoints/#{webhook_endpoint_id}", **params)
        end

        def _delete_webhook_endpoint(webhook_endpoint_id)
          @client.delete(version: :v1).call("webhook_endpoints/#{webhook_endpoint_id}")
        end

        def _test_webhook_endpoint(webhook_endpoint_id, type:)
          @client.post(version: :v1).call("webhook_endpoints/#{webhook_endpoint_id}/test", type:)
        end

        def build_webhook_endpoint(data)
          Fintoc::V1::WebhookEndpoint.new(**data, client: @client)
        end
      end
    end
  end
end
