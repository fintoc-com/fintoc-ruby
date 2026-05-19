require 'fintoc/v1/managers/webhook_endpoints_manager'

RSpec.describe Fintoc::V1::Managers::WebhookEndpointsManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:patch_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:webhook_endpoint_id) { 'we_123' }
  let(:url) { 'https://example.com/webhook' }
  let(:enabled_events) { ['account.refresh_intent.succeeded'] }
  let(:type) { 'account.refresh_intent.succeeded' }
  let(:first_webhook_endpoint_data) do
    {
      id: webhook_endpoint_id,
      object: 'webhook_endpoint',
      url: url,
      mode: 'test',
      enabled_events: enabled_events,
      secret: 'whsec_abc123',
      disabled: false,
      created_at: '2026-05-15T12:00:00.000Z'
    }
  end
  let(:second_webhook_endpoint_data) do
    {
      id: 'we_456',
      object: 'webhook_endpoint',
      url: 'https://example.com/other-webhook',
      mode: 'test',
      enabled_events: enabled_events,
      secret: 'whsec_def456',
      disabled: false,
      created_at: '2026-05-15T12:01:00.000Z'
    }
  end
  let(:updated_webhook_endpoint_data) do
    first_webhook_endpoint_data.merge(url: 'https://example.com/updated')
  end

  before do
    allow(client).to receive(:get).with(version: :v1).and_return(get_proc)
    allow(client).to receive(:post).with(version: :v1, idempotency_key: nil).and_return(post_proc)
    allow(client).to receive(:post).with(version: :v1).and_return(post_proc)
    allow(client).to receive(:patch).with(version: :v1, idempotency_key: nil).and_return(patch_proc)

    allow(get_proc)
      .to receive(:call)
      .with("webhook_endpoints/#{webhook_endpoint_id}")
      .and_return(first_webhook_endpoint_data)
    allow(get_proc)
      .to receive(:call)
      .with('webhook_endpoints')
      .and_return([first_webhook_endpoint_data, second_webhook_endpoint_data])
    allow(post_proc)
      .to receive(:call)
      .with('webhook_endpoints', url:, enabled_events:)
      .and_return(first_webhook_endpoint_data)
    allow(post_proc)
      .to receive(:call)
      .with("webhook_endpoints/#{webhook_endpoint_id}/test", type:)
      .and_return(first_webhook_endpoint_data)
    allow(patch_proc)
      .to receive(:call)
      .with("webhook_endpoints/#{webhook_endpoint_id}", url: 'https://example.com/updated')
      .and_return(updated_webhook_endpoint_data)

    allow(Fintoc::V1::WebhookEndpoint).to receive(:new)
  end

  describe '#create' do
    it 'calls build_webhook_endpoint with the response' do
      manager.create(url:, enabled_events:)
      expect(Fintoc::V1::WebhookEndpoint)
        .to have_received(:new).with(**first_webhook_endpoint_data, client:)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client).to receive(:post).with(version: :v1, idempotency_key:).and_return(post_proc)
      end

      it 'passes idempotency_key to the POST method' do
        manager.create(url:, enabled_events:, idempotency_key:)

        expect(client).to have_received(:post).with(version: :v1, idempotency_key:)
        expect(Fintoc::V1::WebhookEndpoint)
          .to have_received(:new).with(**first_webhook_endpoint_data, client:)
      end
    end
  end

  describe '#get' do
    it 'calls build_webhook_endpoint with the response' do
      manager.get(webhook_endpoint_id)
      expect(Fintoc::V1::WebhookEndpoint)
        .to have_received(:new).with(**first_webhook_endpoint_data, client:)
    end
  end

  describe '#list' do
    it 'calls build_webhook_endpoint for each response' do
      manager.list
      expect(Fintoc::V1::WebhookEndpoint)
        .to have_received(:new).with(**first_webhook_endpoint_data, client:)
      expect(Fintoc::V1::WebhookEndpoint)
        .to have_received(:new).with(**second_webhook_endpoint_data, client:)
    end
  end

  describe '#update' do
    it 'calls build_webhook_endpoint with the response' do
      manager.update(webhook_endpoint_id, url: 'https://example.com/updated')
      expect(Fintoc::V1::WebhookEndpoint)
        .to have_received(:new).with(**updated_webhook_endpoint_data, client:)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client).to receive(:patch).with(version: :v1, idempotency_key:).and_return(patch_proc)
      end

      it 'passes idempotency_key to the PATCH method' do
        manager.update(webhook_endpoint_id, url: 'https://example.com/updated', idempotency_key:)

        expect(client).to have_received(:patch).with(version: :v1, idempotency_key:)
      end
    end
  end

  describe '#delete' do
    let(:delete_proc) { instance_double(Proc) }

    before do
      allow(client).to receive(:delete).with(version: :v1).and_return(delete_proc)
      allow(delete_proc)
        .to receive(:call)
        .with("webhook_endpoints/#{webhook_endpoint_id}")
        .and_return(true)
    end

    it 'calls delete on the client' do
      expect(manager.delete(webhook_endpoint_id)).to be true
    end
  end

  describe '#test' do
    it 'calls build_webhook_endpoint with the response' do
      manager.test(webhook_endpoint_id, type:)

      expect(Fintoc::V1::WebhookEndpoint)
        .to have_received(:new).with(**first_webhook_endpoint_data, client:)
    end
  end
end
