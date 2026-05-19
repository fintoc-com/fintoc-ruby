require 'fintoc/v1/resources/webhook_endpoint'

RSpec.describe Fintoc::V1::WebhookEndpoint do
  subject(:webhook_endpoint) { described_class.new(**data) }

  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { Fintoc::V1::Client.new(api_key) }

  let(:data) do
    {
      id: 'we_Kasf91034gj1AD',
      object: 'webhook_endpoint',
      url: 'https://example.com/webhook',
      mode: 'test',
      enabled_events: ['account.refresh_intent.succeeded'],
      secret: 'whsec_abc123',
      disabled: false,
      created_at: '2026-05-15T12:00:00.000Z',
      client: client
    }
  end

  describe '#initialize' do
    it 'assigns all attributes correctly' do
      expect(webhook_endpoint).to have_attributes(
        id: 'we_Kasf91034gj1AD',
        object: 'webhook_endpoint',
        url: 'https://example.com/webhook',
        mode: 'test',
        enabled_events: ['account.refresh_intent.succeeded'],
        secret: 'whsec_abc123',
        disabled: false,
        created_at: '2026-05-15T12:00:00.000Z'
      )
    end
  end

  describe '#to_s' do
    it 'returns a string representation' do
      expected = '🔔 https://example.com/webhook (we_Kasf91034gj1AD)'
      expect(webhook_endpoint.to_s).to eq(expected)
    end
  end

  describe '#disabled?' do
    context 'when disabled is true' do
      let(:data) do
        super().merge(disabled: true)
      end

      it 'returns true' do
        expect(webhook_endpoint.disabled?).to be true
      end
    end

    context 'when disabled is false' do
      it 'returns false' do
        expect(webhook_endpoint.disabled?).to be false
      end
    end
  end
end
