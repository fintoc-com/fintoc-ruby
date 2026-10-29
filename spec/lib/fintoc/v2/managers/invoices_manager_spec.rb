require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::InvoicesManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_invoices') }
  let(:manager) { client.invoices }
  let(:collection_url) { 'https://api.fintoc.com/v2/invoices' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/invoice.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        customer: 'cus_2c4mDe9NJyGmMzvCqLkXqAtjnRu',
        lines: [{ amount: 30000, currency: 'CLP', quantity: 1, name: 'Premium Plan' }],
        collection_method: 'send_invoice'
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the invoice' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { subscription: 'sub_test', limit: 10 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns invoices' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V2::Invoice).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the invoice' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end

  describe '#update' do
    let(:params) { { metadata: { order_id: '1234' } } }

    before do
      stub_request(:patch, resource_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'updates the invoice' do
      expect(manager.update(payload[:id], **params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end

  describe '#finalize' do
    before do
      stub_request(:post, "#{resource_url}/finalize")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the invoice' do
      expect(manager.finalize(payload[:id]))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end

  describe '#pay' do
    let(:params) { { external_payment: true } }

    before do
      stub_request(:post, "#{resource_url}/pay")
        .with(body: params)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the invoice' do
      expect(manager.pay(payload[:id], **params))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end

  describe '#void' do
    before do
      stub_request(:post, "#{resource_url}/void")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the invoice' do
      expect(manager.void(payload[:id]))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end

  describe '#mark_uncollectible' do
    before do
      stub_request(:post, "#{resource_url}/mark_uncollectible")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the invoice' do
      expect(manager.mark_uncollectible(payload[:id]))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end

  describe '#add_lines' do
    let(:params) do
      {
        lines: [{ amount: 30000, currency: 'CLP', quantity: 1, name: 'Premium Plan' }]
      }
    end

    before do
      stub_request(:post, "#{resource_url}/add_lines")
        .with(body: params)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the invoice' do
      expect(manager.add_lines(payload[:id], **params))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end

  describe '#remove_lines' do
    let(:params) { { lines: ['il_2bVdX0PqJs6RhNu9FmZlTo2EyKq'] } }

    before do
      stub_request(:post, "#{resource_url}/remove_lines")
        .with(body: params)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the invoice' do
      expect(manager.remove_lines(payload[:id], **params))
        .to be_a(Fintoc::V2::Invoice).and have_attributes(payload)
    end
  end
end
