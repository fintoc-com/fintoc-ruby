require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Subscription do
  let(:client) { Fintoc::V2::Client.new('sk_test_subscription') }
  let(:subscription) { described_class.new(**fixture('subscription'), client:) }
  let(:item) { fixture('subscription_item') }

  def fixture(name)
    JSON.parse(File.read("spec/fixtures/v2/#{name}.json"), symbolize_names: true)
  end

  describe '#subscription_items' do
    before do
      stub_request(:patch, "https://api.fintoc.com/v2/subscriptions/#{subscription.id}/items/#{item[:id]}")
        .with(body: { quantity: 3 })
        .to_return(body: item.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'scopes subscription items to the subscription' do
      expect(subscription.subscription_items.update(item[:id], quantity: 3))
        .to be_a(Fintoc::V2::SubscriptionItem).and have_attributes(item)
    end
  end

  describe '#to_s' do
    it 'includes the resource ID and status' do
      expect(subscription.to_s).to eq('Subscription (sub_2c4mDcMaVxDx7nT3o5GbPMQbS2v) - active')
    end
  end
end
