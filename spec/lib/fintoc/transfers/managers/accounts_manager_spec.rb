require 'fintoc/transfers/managers/accounts_manager'

RSpec.describe Fintoc::Transfers::Managers::AccountsManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:patch_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:account_id) { 'acc_123' }
  let(:entity_id) { 'ent_123' }
  let(:first_account_data) do
    {
      id: account_id,
      name: 'My account',
      official_name: 'My account',
      number: '1234567890',
      holder_id: '1234567890',
      holder_name: 'My account',
      type: 'checking',
      currency: 'MXN',
      refreshed_at: '2021-01-01',
      balance: {
        available: 100000,
        current: 100000,
        limit: 0
      },
      movements: []
    }
  end
  let(:second_account_data) do
    {
      id: 'acc_456',
      name: 'My second account',
      official_name: 'My second account',
      number: '0987654321',
      holder_id: '1234567890',
      holder_name: 'My account',
      type: 'checking',
      currency: 'MXN',
      refreshed_at: '2021-01-01',
      balance: {
        available: 100000,
        current: 100000,
        limit: 0
      },
      movements: []
    }
  end
  let(:updated_account_data) do
    first_account_data.merge(name: 'Updated name')
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)
    allow(client).to receive(:post).with(version: :v2).and_return(post_proc)
    allow(client).to receive(:patch).with(version: :v2).and_return(patch_proc)

    allow(get_proc)
      .to receive(:call)
      .with("accounts/#{account_id}")
      .and_return(first_account_data)
    allow(get_proc)
      .to receive(:call)
      .with('accounts')
      .and_return([first_account_data, second_account_data])
    allow(patch_proc)
      .to receive(:call)
      .with("accounts/#{account_id}", name: 'Updated name')
      .and_return(updated_account_data)
    allow(post_proc)
      .to receive(:call)
      .with('accounts', entity_id:, description: 'My account')
      .and_return(first_account_data)

    allow(Fintoc::Transfers::Account).to receive(:new)
  end

  describe '#create' do
    it 'calls build_account with the response' do
      manager.create(entity_id:, description: 'My account')
      expect(Fintoc::Transfers::Account)
        .to have_received(:new).with(**first_account_data, client:)
    end
  end

  describe '#get' do
    it 'calls build_account with the response' do
      manager.get(account_id)
      expect(Fintoc::Transfers::Account)
        .to have_received(:new).with(**first_account_data, client:)
    end
  end

  describe '#list' do
    it 'calls build_account for each response' do
      manager.list
      expect(Fintoc::Transfers::Account)
        .to have_received(:new).with(**first_account_data, client:)
      expect(Fintoc::Transfers::Account)
        .to have_received(:new).with(**second_account_data, client:)
    end
  end

  describe '#update' do
    it 'calls build_account with the response' do
      manager.update(account_id, name: 'Updated name')
      expect(Fintoc::Transfers::Account)
        .to have_received(:new).with(**updated_account_data, client:)
    end
  end
end
