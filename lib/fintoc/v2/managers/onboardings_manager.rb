require 'fintoc/v2/resources/onboarding'

module Fintoc
  module V2
    module Managers
      class OnboardingsManager
        def initialize(client, entity_id)
          @client = client
          @entity_id = entity_id
        end

        def list(**params)
          _list_onboardings(**params).map { |data| build_onboarding(data) }
        end

        def get(onboarding_id)
          data = _get_onboarding(onboarding_id)
          build_onboarding(data)
        end

        def create(idempotency_key: nil, **params)
          data = _create_onboarding(idempotency_key:, **params)
          build_onboarding(data)
        end

        def submit(onboarding_id, idempotency_key: nil)
          data = _submit_onboarding(onboarding_id, idempotency_key:)
          build_onboarding(data)
        end

        def upload_document(onboarding_id, slot_key, file:, idempotency_key: nil)
          data = _upload_document(onboarding_id, slot_key, file:, idempotency_key:)
          build_onboarding(data)
        end

        def upload_shareholder_document(onboarding_id, shareholder_id, file:, idempotency_key: nil)
          data = _upload_shareholder_document(
            onboarding_id, shareholder_id, file:, idempotency_key:
          )
          build_onboarding(data)
        end

        private

        def base_path
          "entities/#{@entity_id}/onboardings"
        end

        def _list_onboardings(**params)
          @client.get(version: :v2).call(base_path, **params)
        end

        def _get_onboarding(onboarding_id)
          @client.get(version: :v2).call("#{base_path}/#{onboarding_id}")
        end

        def _create_onboarding(idempotency_key: nil, **params)
          @client.post(version: :v2, idempotency_key:).call(base_path, **params)
        end

        def _submit_onboarding(onboarding_id, idempotency_key: nil)
          @client.post(version: :v2, idempotency_key:)
                 .call("#{base_path}/#{onboarding_id}/submit")
        end

        def _upload_document(onboarding_id, slot_key, file:, idempotency_key: nil)
          @client.put(version: :v2, idempotency_key:).call(
            "#{base_path}/#{onboarding_id}/documents/#{slot_key}",
            form: { file: }
          )
        end

        def _upload_shareholder_document(onboarding_id, shareholder_id, file:, idempotency_key: nil)
          @client.put(version: :v2, idempotency_key:).call(
            "#{base_path}/#{onboarding_id}/shareholders/#{shareholder_id}/document",
            form: { file: }
          )
        end

        def build_onboarding(data)
          Fintoc::V2::Onboarding.new(**data, client: @client)
        end
      end
    end
  end
end
