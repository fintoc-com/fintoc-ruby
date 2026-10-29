require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::PaymentMethodsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_payment_methods') }
  let(:manager) { client.payment_methods }
  let(:collection_url) { 'https://api.fintoc.com/v2/payment_methods' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/payment_method.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:file_path) { 'spec/support/fixtures/sample_document.pdf' }
    let(:mx_direct_debit) do
      {
        account_number: '000000000000000000',
        account_type: 'clabe',
        interval: 'month',
        max_amount: 100000,
        account_holder: { rfc: 'AAA010101AAA' },
        consent_documents: { contract: file_path, selfie: file_path,
                             id_front: file_path, id_back: file_path }
      }
    end
    let(:expected_parts) do
      [
        'name="type"', 'name="customer"', 'name="mx_direct_debit[account_number]"',
        'name="mx_direct_debit[max_amount]"', 'name="mx_direct_debit[account_holder][rfc]"',
        'name="mx_direct_debit[consent_documents][contract]"; filename="sample_document.pdf"',
        'name="mx_direct_debit[consent_documents][id_back]"; filename="sample_document.pdf"'
      ]
    end

    before do
      stub_request(:post, collection_url)
        .with(headers: { 'Content-Type' => %r{\Amultipart/form-data},
                         'Idempotency-Key' => 'idem-key' }) do |request|
        expected_parts.all? { |part| request.body.include?(part) }
      end
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'sends nested fields and documents as multipart bracket keys' do
      result = manager.create(
        type: 'mx_direct_debit', customer: 'cus_test', mx_direct_debit:, idempotency_key: 'idem-key'
      )

      expect(result).to be_a(Fintoc::V2::PaymentMethod).and have_attributes(payload)
    end

    it 'sends non-document fields as plain values even when they match a file path' do
      manager.create(type: 'mx_direct_debit', customer: file_path, mx_direct_debit:,
                     idempotency_key: 'idem-key')

      expect(a_request(:post, collection_url).with do |request|
        request.body.include?("name=\"customer\"\r\n\r\n#{file_path}\r\n")
      end).to have_been_made
    end
  end

  describe '#list' do
    let(:filters) { { customer: 'cus_test', limit: 10 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns payment methods' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V2::PaymentMethod).and(have_attributes(payload)))
    end

    it 'sends nested filters in bracket notation' do
      stub_request(:get, "#{collection_url}?payment_options%5Bamount%5D=1000")
        .to_return(body: [payload].to_json, headers: headers)

      expect(manager.list(payment_options: { amount: 1000 })).to contain_exactly(a_kind_of(Fintoc::V2::PaymentMethod))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url).to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payment method' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::PaymentMethod).and have_attributes(payload)
    end
  end

  describe '#cancel' do
    before do
      stub_request(:post, "#{resource_url}/cancel")
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payment method' do
      expect(manager.cancel(payload[:id]))
        .to be_a(Fintoc::V2::PaymentMethod).and have_attributes(payload)
    end
  end

  describe '#mandate_document' do
    let(:response) do
      { download_url: 'https://example.com/mandate.pdf', expires_at: '2026-01-10T12:05:00Z',
        filename: 'mandate.pdf' }
    end

    before do
      stub_request(:get, "#{resource_url}/mandate_document")
        .to_return(body: response.to_json, headers: headers)
    end

    it 'returns the download information' do
      expect(manager.mandate_document(payload[:id])).to eq(response)
    end
  end
end
