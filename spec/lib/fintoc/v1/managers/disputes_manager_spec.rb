require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::DisputesManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_disputes') }
  let(:manager) { client.disputes }
  let(:collection_url) { 'https://api.fintoc.com/v1/disputes' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/dispute.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#list' do
    let(:filters) { { status: 'needs_response', resource_id: 'pi_test' } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns disputes' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::Dispute).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url).to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the dispute' do
      expect(manager.get(payload[:id])).to be_a(Fintoc::V1::Dispute).and have_attributes(payload)
    end
  end

  describe '#submit_for_review' do
    before do
      stub_request(:post, "#{resource_url}/submit_for_review")
        .with(headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the dispute' do
      expect(manager.submit_for_review(payload[:id], idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::Dispute).and have_attributes(payload)
    end
  end

  describe '#create_document' do
    let(:document) do
      JSON.parse(File.read('spec/fixtures/v1/dispute_document.json'), symbolize_names: true)
    end
    let(:file_path) { 'spec/support/fixtures/sample_document.pdf' }

    before do
      stub_request(:post, "#{resource_url}/documents")
        .with(headers: { 'Content-Type' => %r{\Amultipart/form-data} }) do |request|
          request.body.include?('name="file"; filename="sample_document.pdf"')
        end
        .to_return(status: 201, body: document.to_json, headers: headers)
    end

    it 'uploads the file as multipart and returns the document' do
      expect(manager.create_document(payload[:id], file: file_path))
        .to be_a(Fintoc::V1::DisputeDocument).and have_attributes(document)
    end
  end
end
