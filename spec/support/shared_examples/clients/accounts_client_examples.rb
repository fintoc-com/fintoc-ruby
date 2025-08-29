RSpec.shared_examples 'a client with accounts methods' do
  let(:account_id) { 'acc_31yYL7h9LVPg121AgFtCyJPDsgM' }
  let(:entity_id) { 'ent_31t0VhhrAXASFQTVYfCfIBnljbT' }

  it 'responds to account-specific methods' do
    expect(client)
      .to respond_to(:create_account)
      .and respond_to(:get_account)
      .and respond_to(:list_accounts)
      .and respond_to(:update_account)
  end

  describe '#create_account' do
    it 'returns an Account instance', :vcr do
      account = client.create_account(entity_id:, description: 'Test account')

      expect(account)
        .to be_an_instance_of(Fintoc::Transfers::Account)
        .and have_attributes(
          description: 'Test account',
          currency: 'MXN',
          status: 'active'
        )
    end
  end

  describe '#get_account' do
    it 'returns an Account instance', :vcr do
      account = client.get_account(account_id)

      expect(account)
        .to be_an_instance_of(Fintoc::Transfers::Account)
        .and have_attributes(
          id: account_id,
          description: 'Test account'
        )
    end
  end

  describe '#list_accounts' do
    it 'returns an array of Account instances', :vcr do
      accounts = client.list_accounts

      expect(accounts).to all(be_a(Fintoc::Transfers::Account))
      expect(accounts.size).to be >= 1
      expect(accounts.first.id).to eq(account_id)
    end
  end

  describe '#update_account' do
    it 'returns an updated Account instance', :vcr do
      updated_description = 'Updated account description'
      account = client.update_account(account_id, description: updated_description)

      expect(account)
        .to be_an_instance_of(Fintoc::Transfers::Account)
        .and have_attributes(
          id: account_id,
          description: updated_description
        )
    end
  end
end
