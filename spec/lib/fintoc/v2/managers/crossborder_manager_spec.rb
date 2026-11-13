require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::CrossborderManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_crossborder') }
  let(:base_url) { 'https://api.fintoc.com/v2/crossborder' }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  def fixture(name)
    JSON.parse(File.read("spec/fixtures/v2/#{name}.json"), symbolize_names: true)
  end

  it 'is memoized on the v2 client' do
    expect(client.crossborder).to equal(client.crossborder)
  end

  describe 'resources #to_s' do
    it 'describes each crossborder resource' do
      expect(
        [
          Fintoc::V2::CrossborderBeneficiary.new(**fixture('crossborder_beneficiary')).to_s,
          Fintoc::V2::CrossborderQuote.new(**fixture('crossborder_quote')).to_s,
          Fintoc::V2::CrossborderTransfer.new(**fixture('crossborder_transfer')).to_s
        ]
      ).to eq(
        [
          'Crossborder beneficiary (xbb_2u6XjsX2BD3F8MzKQJf4Tr7Pcxw) - ' \
          'JPMorgan Chase Bank, N.A. ****6789',
          'Crossborder quote (xbq_2u6XjsX2BD3F8MzKQJf4Tr7Pcxw) - mx_to_usd open',
          'Crossborder transfer (xbt_2u6XjsX2BD3F8MzKQJf4Tr7Pcxw) - mx_to_usd pending_funds'
        ]
      )
    end
  end

  describe '#beneficiaries' do
    let(:manager) { client.crossborder.beneficiaries }
    let(:payload) { fixture('crossborder_beneficiary') }
    let(:collection_url) { "#{base_url}/beneficiaries" }
    let(:resource_url) { "#{collection_url}/#{payload[:id]}" }

    describe '#create' do
      let(:params) do
        { holder_type: 'business', account_identifier: '123456789',
          routing_number: payload[:routing_number], bank_name: payload[:bank_name],
          address: payload[:address].compact, business_name: payload[:business_name] }
      end

      before do
        stub_request(:post, collection_url)
          .with(body: params.to_json, headers: { 'Idempotency-Key' => 'beneficiary-create' })
          .to_return(status: 201, body: payload.to_json, headers: headers)
      end

      it 'creates the beneficiary' do
        expect(manager.create(**params, idempotency_key: 'beneficiary-create'))
          .to be_a(Fintoc::V2::CrossborderBeneficiary).and have_attributes(payload)
      end
    end

    describe '#list' do
      let(:filters) { { starting_after: 'xbb_previous', ending_before: 'xbb_next', limit: 1 } }

      before do
        stub_request(:get, collection_url).with(query: filters)
                                          .to_return(body: [payload].to_json, headers: headers)
      end

      it 'passes pagination parameters' do
        expect(manager.list(**filters)).to contain_exactly(
          a_kind_of(Fintoc::V2::CrossborderBeneficiary).and(have_attributes(payload))
        )
      end
    end

    describe '#get' do
      before do
        stub_request(:get, resource_url).to_return(body: payload.to_json, headers: headers)
      end

      it 'returns the beneficiary' do
        expect(manager.get(payload[:id]))
          .to be_a(Fintoc::V2::CrossborderBeneficiary).and have_attributes(archived?: false)
      end
    end

    describe '#delete' do
      let(:archived) { payload.merge(archived_at: '2026-11-09T12:00:00Z') }

      before do
        stub_request(:delete, resource_url).to_return(body: archived.to_json, headers: headers)
      end

      it 'returns the archived beneficiary' do
        expect(manager.delete(payload[:id]))
          .to have_attributes(**archived, archived?: true)
      end
    end
  end

  describe '#quotes' do
    let(:manager) { client.crossborder.quotes }
    let(:payload) { fixture('crossborder_quote') }

    describe '#create' do
      let(:params) { { direction: 'mx_to_usd', source_amount: 200001 } }

      before do
        stub_request(:post, "#{base_url}/quotes")
          .with(body: params.to_json, headers: { 'Idempotency-Key' => 'quote-create' })
          .to_return(status: 201, body: payload.to_json, headers: headers)
      end

      it 'creates the quote' do
        expect(manager.create(**params, idempotency_key: 'quote-create'))
          .to be_a(Fintoc::V2::CrossborderQuote).and have_attributes(payload)
      end
    end

    describe '#get' do
      before do
        stub_request(:get, "#{base_url}/quotes/#{payload[:id]}")
          .to_return(body: payload.to_json, headers: headers)
      end

      it 'returns the quote' do
        expect(manager.get(payload[:id]))
          .to be_a(Fintoc::V2::CrossborderQuote).and have_attributes(payload)
      end
    end

    describe 'errors' do
      before do
        stub_request(:post, "#{base_url}/quotes").to_return(
          status: 503, headers: headers,
          body: { error: { type: 'api_error', code: 'provider_unavailable',
                           message: 'Provider unavailable' } }.to_json
        )
      end

      it 'raises the provider unavailable error' do
        expect { manager.create(direction: 'mx_to_usd', source_amount: 200001) }
          .to raise_error(Fintoc::Errors::ProviderUnavailableError) { |error|
            expect(error).to have_attributes(status: 503, code: 'provider_unavailable')
          }
      end
    end
  end

  describe '#transfers' do
    let(:manager) { client.crossborder.transfers }
    let(:payload) { fixture('crossborder_transfer') }
    let(:collection_url) { "#{base_url}/transfers" }
    let(:expected_attributes) { payload.except(:beneficiary) }

    describe '#create' do
      let(:params) do
        { quote_id: payload[:quote_id], beneficiary_id: payload[:beneficiary][:id],
          reference: payload[:reference] }
      end

      before do
        stub_request(:post, collection_url)
          .with(body: params.to_json, headers: { 'Idempotency-Key' => 'transfer-create' })
          .to_return(status: 201, body: payload.to_json, headers: headers)
      end

      it 'creates the transfer and builds its beneficiary' do
        expect(manager.create(**params, idempotency_key: 'transfer-create'))
          .to be_a(Fintoc::V2::CrossborderTransfer)
          .and have_attributes(
            **expected_attributes,
            beneficiary: a_kind_of(Fintoc::V2::CrossborderBeneficiary)
              .and(have_attributes(payload[:beneficiary]))
          )
      end
    end

    describe '#list' do
      before do
        stub_request(:get, "#{collection_url}?direction=mx_to_usd&limit=10" \
                           '&status%5B%5D=pending_funds&status%5B%5D=failed')
          .to_return(body: [payload.merge(beneficiary: nil)].to_json, headers: headers)
      end

      it 'sends the status filter as status[]' do
        expect(manager.list(status: %w[pending_funds failed], direction: 'mx_to_usd', limit: 10))
          .to contain_exactly(have_attributes(**expected_attributes, beneficiary: nil))
      end
    end

    describe '#get' do
      before do
        stub_request(:get, "#{collection_url}/#{payload[:id]}")
          .to_return(body: payload.to_json, headers: headers)
      end

      it 'returns the transfer' do
        expect(manager.get(payload[:id]))
          .to be_a(Fintoc::V2::CrossborderTransfer).and have_attributes(expected_attributes)
      end
    end
  end
end
