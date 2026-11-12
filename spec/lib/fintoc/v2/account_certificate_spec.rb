require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::AccountCertificate do
  let(:client) { Fintoc::V2::Client.new('sk_test_certificates') }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/account_certificate.json'), symbolize_names: true)
  end
  let(:account_id) { payload[:account_id] }
  let(:account_number_id) { payload[:account_number_id] }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  before do
    stub_request(:get, "https://api.fintoc.com/v2/accounts/#{account_id}/certificate")
      .to_return(body: payload.to_json, headers: headers)
    stub_request(:get, "https://api.fintoc.com/v2/account_numbers/#{account_number_id}/certificate")
      .to_return(body: payload.to_json, headers: headers)
  end

  describe 'accounts manager #certificate' do
    it 'returns the account certificate' do
      expect(client.accounts.certificate(account_id))
        .to be_a(described_class).and have_attributes(payload)
    end
  end

  describe 'account numbers manager #certificate' do
    it 'returns the account certificate' do
      expect(client.account_numbers.certificate(account_number_id))
        .to be_a(described_class).and have_attributes(payload)
    end
  end

  describe 'Account#certificate' do
    let(:account) do
      Fintoc::V2::Account.new(
        id: account_id, object: 'account', mode: 'test', description: 'Main',
        available_balance: 0, currency: 'MXN', is_root: true,
        root_account_number_id: account_number_id, root_account_number: '738969123456789120',
        status: 'active', entity: {}, client:
      )
    end

    it 'fetches the certificate of the account' do
      expect(account.certificate).to be_a(described_class).and have_attributes(payload)
    end
  end

  describe 'AccountNumber#certificate' do
    let(:account_number) do
      Fintoc::V2::AccountNumber.new(
        id: account_number_id, object: 'account_number', description: 'Main',
        number: '738969123456789120', created_at: '2026-11-09T18:00:00Z',
        updated_at: '2026-11-09T18:00:00Z', mode: 'test', status: 'enabled', is_root: true,
        account_id:, metadata: {}, client:
      )
    end

    it 'fetches the certificate of the account number' do
      expect(account_number.certificate).to be_a(described_class).and have_attributes(payload)
    end
  end

  describe '#to_s' do
    it 'does not expose the signed download URL' do
      expect(described_class.new(**payload).to_s)
        .to eq("📄 Account certificate (#{account_number_id})")
    end
  end
end
