require 'fintoc/v2/managers/subscriptions_manager'

RSpec.describe Fintoc::V2::Managers::SubscriptionsManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:patch_proc) { instance_double(Proc) }
  let(:delete_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:subscription_id) { 'sub_123' }
  let(:item_id) { 'si_123' }
  let(:price_data) { { product: 'prod_123', amount: 10_000, currency: 'CLP' } }
  let(:item_data) do
    { id: item_id, object: 'subscription_item', price: { id: 'price_123' }, quantity: 1 }
  end
  let(:items) { [{ price: 'price_123', quantity: 1 }] }
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
    allow(client).to receive_messages(post: post_proc, patch: patch_proc)
    allow(client).to receive(:delete).with(version: :v2).and_return(delete_proc)

    allow(get_proc)
      .to receive(:call)
      .with('subscriptions')
      .and_return([first_subscription_data, second_subscription_data])

    allow(get_proc)
      .to receive(:call)
      .with("subscriptions/#{subscription_id}")
      .and_return(first_subscription_data)

    allow(post_proc)
      .to receive(:call)
      .with('subscriptions', customer: 'cus_123', items:)
      .and_return(first_subscription_data)

    allow(patch_proc)
      .to receive(:call)
      .with("subscriptions/#{subscription_id}", trial_end: '2026-12-31T00:00:00Z')
      .and_return(first_subscription_data)

    allow(post_proc)
      .to receive(:call)
      .with("subscriptions/#{subscription_id}/cancel")
      .and_return(first_subscription_data)

    allow(post_proc)
      .to receive(:call)
      .with("subscriptions/#{subscription_id}/items", price_data:, quantity: 1)
      .and_return(item_data)

    allow(Fintoc::V2::Subscription).to receive(:new)
    allow(patch_proc)
      .to receive(:call)
      .with("subscriptions/#{subscription_id}/items/#{item_id}", quantity: 2)
      .and_return(item_data)

    allow(delete_proc)
      .to receive(:call)
      .with("subscriptions/#{subscription_id}/items/#{item_id}")
      .and_return(item_data)

    allow(Fintoc::V2::SubscriptionItem).to receive(:new)
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

  describe '#get' do
    it 'calls build_subscription with the response' do
      manager.get(subscription_id)
      expect(Fintoc::V2::Subscription)
        .to have_received(:new).with(**first_subscription_data, client:)
    end
  end

  describe '#create' do
    it 'posts to subscriptions and builds the subscription' do
      manager.create(customer: 'cus_123', items:)
      expect(post_proc)
        .to have_received(:call).with('subscriptions', customer: 'cus_123', items:)
      expect(Fintoc::V2::Subscription)
        .to have_received(:new).with(**first_subscription_data, client:)
    end
  end

  describe '#update' do
    it 'patches the subscription and builds it' do
      manager.update(subscription_id, trial_end: '2026-12-31T00:00:00Z')
      expect(patch_proc)
        .to have_received(:call).with("subscriptions/#{subscription_id}",
                                      trial_end: '2026-12-31T00:00:00Z')
      expect(Fintoc::V2::Subscription)
        .to have_received(:new).with(**first_subscription_data, client:)
    end
  end

  describe '#cancel' do
    it 'posts to the cancel path and builds the subscription' do
      manager.cancel(subscription_id)
      expect(post_proc)
        .to have_received(:call).with("subscriptions/#{subscription_id}/cancel")
      expect(Fintoc::V2::Subscription)
        .to have_received(:new).with(**first_subscription_data, client:)
    end
  end

  describe '#create_item' do
    it 'posts to the items path and builds the subscription item' do
      manager.create_item(subscription_id, price_data:, quantity: 1)
      expect(post_proc)
        .to have_received(:call).with("subscriptions/#{subscription_id}/items", price_data:,
                                                                                quantity: 1)
      expect(Fintoc::V2::SubscriptionItem)
        .to have_received(:new).with(**item_data)
    end
  end

  describe '#update_item' do
    it 'patches the item path and builds the subscription item' do
      manager.update_item(subscription_id, item_id, quantity: 2)
      expect(patch_proc)
        .to have_received(:call).with("subscriptions/#{subscription_id}/items/#{item_id}",
                                      quantity: 2)
      expect(Fintoc::V2::SubscriptionItem)
        .to have_received(:new).with(**item_data)
    end
  end

  describe '#delete_item' do
    it 'deletes the item path and builds the subscription item' do
      manager.delete_item(subscription_id, item_id)
      expect(delete_proc)
        .to have_received(:call).with("subscriptions/#{subscription_id}/items/#{item_id}")
      expect(Fintoc::V2::SubscriptionItem)
        .to have_received(:new).with(**item_data)
    end
  end
end
