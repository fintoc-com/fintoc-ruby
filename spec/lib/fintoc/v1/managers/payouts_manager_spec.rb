require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::PayoutsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_payouts') }
  let(:manager) { client.payouts }
  let(:collection_url) { 'https://api.fintoc.com/v1/payouts' }
  let(:payload) { fixture('payout') }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  def fixture(name)
    JSON.parse(File.read("spec/fixtures/v1/#{name}.json"), symbolize_names: true)
  end

  describe '#list' do
    let(:filters) { { since: '2026-01-01', status: 'succeeded', page: 1, per_page: 30 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns payouts' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::Payout).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, "#{collection_url}/#{payload[:id]}")
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payout' do
      expect(manager.get(payload[:id])).to be_a(Fintoc::V1::Payout).and have_attributes(payload)
    end
  end

  describe '#list_resources' do
    let(:resources) { [fixture('payment_intent'), fixture('charge'), fixture('refund'), unknown] }
    let(:unknown) { { id: 'x_1', object: 'something_else' } }

    before do
      stub_request(:get, "#{collection_url}/#{payload[:id]}/resources")
        .with(query: { resource_type: 'payment_intent', page: 1 })
        .to_return(body: resources.to_json, headers: headers)
    end

    it 'builds each resource from its object type' do
      expect(manager.list_resources(payload[:id], resource_type: 'payment_intent', page: 1))
        .to match([
                    a_kind_of(Fintoc::V1::PaymentIntent).and(have_attributes(resources[0])),
                    a_kind_of(Fintoc::V1::Charge).and(have_attributes(resources[1])),
                    a_kind_of(Fintoc::V1::Refund).and(have_attributes(resources[2])),
                    unknown
                  ])
    end
  end
end
