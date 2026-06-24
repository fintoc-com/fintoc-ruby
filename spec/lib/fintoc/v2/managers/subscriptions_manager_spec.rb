require 'fintoc/v2/managers/subscriptions_manager'

RSpec.describe Fintoc::V2::Managers::SubscriptionsManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:subscription_id) { 'sub_123' }
  let(:first_subscription_data) do
    {
      id: subscription_id,
      object: 'subscription',
      billing_cycle_anchor: '2026-01-01T00:00:00Z',
      collection_method: 'send_invoice',
      created_at: '2026-01-01T00:00:00Z',
      currency: 'CLP',
      customer: 'cus_123',
      mode: 'live',
      metadata: {},
      payment_method: nil,
      status: 'active',
      trial_end: nil,
      items: []
    }
  end
  let(:second_subscription_data) do
    {
      id: 'sub_456',
      object: 'subscription',
      billing_cycle_anchor: '2026-02-01T00:00:00Z',
      collection_method: 'send_invoice',
      created_at: '2026-02-01T00:00:00Z',
      currency: 'CLP',
      customer: 'cus_123',
      mode: 'live',
      metadata: {},
      payment_method: nil,
      status: 'active',
      trial_end: nil,
      items: []
    }
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)

    allow(get_proc)
      .to receive(:call)
      .with('subscriptions')
      .and_return([first_subscription_data, second_subscription_data])

    allow(Fintoc::V2::Subscription).to receive(:new)
  end

  describe '#list' do
    it 'calls build_subscription for each response item' do
      manager.list
      expect(Fintoc::V2::Subscription)
        .to have_received(:new).with(**first_subscription_data, client:)
      expect(Fintoc::V2::Subscription)
        .to have_received(:new).with(**second_subscription_data, client:)
    end
  end
end
