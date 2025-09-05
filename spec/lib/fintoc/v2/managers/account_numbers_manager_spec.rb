require 'fintoc/v2/managers/account_numbers_manager'

RSpec.describe Fintoc::V2::Managers::AccountNumbersManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:patch_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:account_number_id) { 'acno_123' }
  let(:account_id) { 'acc_123' }
  let(:first_account_number_data) do
    {
      id: account_number_id,
      object: 'account_number',
      description: 'My account number',
      number: '1234567890',
      created_at: '2021-01-01',
      updated_at: '2021-01-01',
      mode: 'test',
      status: 'enabled',
      is_root: false,
      account_id: account_id,
      metadata: {}
    }
  end
  let(:second_account_number_data) do
    {
      id: 'acno_456',
      object: 'account_number',
      description: 'My second account number',
      number: '0987654321',
      created_at: '2021-01-02',
      updated_at: '2021-01-02',
      mode: 'test',
      status: 'enabled',
      is_root: false,
      account_id: account_id,
      metadata: {}
    }
  end
  let(:updated_account_number_data) do
    first_account_number_data.merge(description: 'Updated description')
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)
    allow(client).to receive(:post).with(version: :v2).and_return(post_proc)
    allow(client).to receive(:patch).with(version: :v2).and_return(patch_proc)

    allow(get_proc)
      .to receive(:call)
      .with("account_numbers/#{account_number_id}")
      .and_return(first_account_number_data)
    allow(get_proc)
      .to receive(:call)
      .with('account_numbers')
      .and_return([first_account_number_data, second_account_number_data])
    allow(patch_proc)
      .to receive(:call)
      .with("account_numbers/#{account_number_id}", description: 'Updated description')
      .and_return(updated_account_number_data)
    allow(post_proc)
      .to receive(:call)
      .with('account_numbers', account_id:, description: 'My account number', metadata: {})
      .and_return(first_account_number_data)

    allow(Fintoc::V2::AccountNumber).to receive(:new)
  end

  describe '#create' do
    it 'calls build_account_number with the response' do
      manager.create(account_id: 'acc_123', description: 'My account number', metadata: {})
      expect(Fintoc::V2::AccountNumber)
        .to have_received(:new).with(**first_account_number_data, client:)
    end
  end

  describe '#get' do
    it 'calls build_account_number with the response' do
      manager.get('acno_123')
      expect(Fintoc::V2::AccountNumber)
        .to have_received(:new).with(**first_account_number_data, client:)
    end
  end

  describe '#list' do
    it 'calls build_account_number for each response' do
      manager.list
      expect(Fintoc::V2::AccountNumber)
        .to have_received(:new).with(**first_account_number_data, client:)
      expect(Fintoc::V2::AccountNumber)
        .to have_received(:new).with(**second_account_number_data, client:)
    end
  end

  describe '#update' do
    it 'calls build_account_number with the response' do
      manager.update('acno_123', description: 'Updated description')
      expect(Fintoc::V2::AccountNumber)
        .to have_received(:new).with(**updated_account_number_data, client:)
    end
  end
end
