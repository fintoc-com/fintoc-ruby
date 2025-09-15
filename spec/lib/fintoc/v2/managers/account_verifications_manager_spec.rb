require 'fintoc/v2/managers/account_verifications_manager'

RSpec.describe Fintoc::V2::Managers::AccountVerificationsManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:account_verification_id) { 'accv_123' }
  let(:account_number) { '735969000000203226' }
  let(:first_account_verification_data) do
    {
      id: account_verification_id,
      object: 'account_verification',
      account_number: account_number,
      status: 'pending'
    }
  end
  let(:second_account_verification_data) do
    {
      id: 'accv_456',
      object: 'account_verification',
      account_number: account_number,
      status: 'pending'
    }
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)
    allow(client)
      .to receive(:post)
      .with(version: :v2, use_jws: true, idempotency_key: nil)
      .and_return(post_proc)

    allow(get_proc)
      .to receive(:call)
      .with("account_verifications/#{account_verification_id}")
      .and_return(first_account_verification_data)
    allow(get_proc)
      .to receive(:call)
      .with('account_verifications')
      .and_return([first_account_verification_data, second_account_verification_data])
    allow(post_proc)
      .to receive(:call)
      .with('account_verifications', account_number:)
      .and_return(first_account_verification_data)

    allow(Fintoc::V2::AccountVerification).to receive(:new)
  end

  describe '#create' do
    it 'calls build_account_verification with the response' do
      manager.create(account_number: '735969000000203226')
      expect(Fintoc::V2::AccountVerification)
        .to have_received(:new).with(**first_account_verification_data, client:)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client)
          .to receive(:post)
          .with(version: :v2, use_jws: true, idempotency_key:)
          .and_return(post_proc)
      end

      it 'passes idempotency_key to the POST method' do
        manager.create(account_number: '735969000000203226', idempotency_key:)

        expect(client).to have_received(:post).with(version: :v2, use_jws: true, idempotency_key:)
      end
    end
  end

  describe '#get' do
    it 'calls build_account_verification with the response' do
      manager.get('accv_123')
      expect(Fintoc::V2::AccountVerification)
        .to have_received(:new).with(**first_account_verification_data, client:)
    end
  end

  describe '#list' do
    it 'calls build_account_verification for each response item' do
      manager.list
      expect(Fintoc::V2::AccountVerification)
        .to have_received(:new).with(**first_account_verification_data, client:)
      expect(Fintoc::V2::AccountVerification)
        .to have_received(:new).with(**second_account_verification_data, client:)
    end
  end
end
