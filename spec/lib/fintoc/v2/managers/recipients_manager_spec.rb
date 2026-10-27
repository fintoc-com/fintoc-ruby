require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::RecipientsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_recipients') }
  let(:manager) { client.recipients }
  let(:collection_url) { 'https://api.fintoc.com/v2/recipients' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read("spec/fixtures/recipient_#{country}.json"), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  shared_examples 'a recipients API' do
    describe '#create' do
      let(:params) do
        { entity_id: 'ent_test', account_number: payload[:account_number],
          holder_name: payload[:holder_name] }.merge(country_params)
      end

      before do
        stub_request(:post, collection_url)
          .with(body: params.to_json, headers: { 'Idempotency-Key' => 'recipient-create' })
          .to_return(status: 201, body: payload.to_json, headers: headers)
      end

      def perform = manager.create(**params, idempotency_key: 'recipient-create')

      it 'returns the recipient with all serialized fields' do
        expect(perform).to be_a(Fintoc::V2::Recipient).and have_attributes(payload)
      end
    end

    describe '#get' do
      before do
        stub_request(:get, resource_url).to_return(body: payload.to_json, headers: headers)
      end

      def perform = manager.get(payload[:id])

      it 'returns a recipient' do
        expect(perform).to be_a(Fintoc::V2::Recipient).and have_attributes(payload)
      end
    end

    describe '#list' do
      let(:filters) do
        { entity_id: 'ent_test', holder_type: 'person', institution_id: payload[:institution][:id],
          holder_id: payload[:holder_id], account_number: payload[:account_number],
          starting_after: 'rcp_previous', ending_before: 'rcp_next', limit: 1 }
      end

      before do
        stub_request(:get, collection_url).with(query: filters)
                                          .to_return(body: [payload].to_json, headers: headers)
      end

      def perform = manager.list(**filters)

      it 'passes filters and pagination parameters' do
        expect(perform).to contain_exactly(a_kind_of(Fintoc::V2::Recipient).and(have_attributes(payload)))
      end
    end

    describe '#update' do
      let(:updates) { { alias: nil, email: nil } }
      let(:updated_payload) { payload.merge(updates) }

      before do
        stub_request(:patch, resource_url)
          .with(body: updates.to_json)
          .to_return(body: updated_payload.to_json, headers: headers)
      end

      def perform = manager.update(payload[:id], **updates)

      it 'preserves explicit nulls' do
        expect(perform).to have_attributes(updated_payload)
      end

      context 'with blank strings' do
        let(:updates) { { alias: '', email: '' } }

        it 'passes blank strings' do
          expect(perform).to have_attributes(updated_payload)
        end
      end

      context 'with omitted contact fields' do
        let(:updates) { { holder_name: 'Updated name' } }

        it 'only sends provided fields' do
          expect(perform).to have_attributes(updated_payload)
        end
      end
    end

    describe '#delete' do
      before do
        stub_request(:delete, resource_url).to_return(status: 204, body: '')
      end

      def perform = manager.delete(payload[:id])

      it 'accepts an empty response' do
        expect(perform).to be_nil
      end
    end

    describe 'recipient instance methods' do
      let(:recipient) { Fintoc::V2::Recipient.new(**payload, client: client) }
      let(:updates) { { alias: nil, email: nil, holder_name: 'Updated name' } }

      before do
        stub_request(:patch, resource_url)
          .with(body: updates.to_json)
          .to_return(body: payload.merge(updates).to_json, headers: headers)
        stub_request(:get, resource_url)
          .to_return(body: payload.merge(holder_name: 'Fresh name').to_json, headers: headers)
        stub_request(:delete, resource_url).to_return(status: 204, body: '')
      end

      it 'updates the same instance and clears contact fields' do
        expect(recipient.update(**updates)).to equal(recipient).and have_attributes(updates)
      end

      it 'refreshes the same instance' do
        expect(recipient.refresh).to equal(recipient).and have_attributes(holder_name: 'Fresh name')
      end

      it 'deletes the recipient' do
        expect(recipient.delete).to be_nil
      end

      context 'when refresh returns another recipient' do
        before do
          stub_request(:get, resource_url)
            .to_return(body: payload.merge(id: 'rcp_other').to_json, headers: headers)
        end

        it 'rejects the mismatched recipient' do
          expect do
            recipient.refresh
          end.to raise_error(ArgumentError, 'Recipient must be the same instance')
        end
      end
    end
  end

  context 'with a Mexican recipient' do
    let(:country) { 'mx' }
    let(:country_params) { {} }

    it_behaves_like 'a recipients API'
  end

  context 'with a Chilean recipient' do
    let(:country) { 'cl' }
    let(:country_params) do
      { institution_id: payload[:institution][:id], holder_id: payload[:holder_id],
        holder_type: payload[:holder_type], account_type: payload[:account_type] }
    end

    it_behaves_like 'a recipients API'
  end
end
