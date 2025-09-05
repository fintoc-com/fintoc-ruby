RSpec.shared_examples 'a client with accounts manager' do
  let(:account_id) { 'acc_31yYL7h9LVPg121AgFtCyJPDsgM' }
  let(:entity_id) { 'ent_31t0VhhrAXASFQTVYfCfIBnljbT' }

  it 'responds to account-specific methods' do
    expect(client).to respond_to(:accounts)
    expect(client.accounts).to be_a(Fintoc::Transfers::Managers::AccountsManager)
    expect(client.accounts)
      .to respond_to(:create)
      .and respond_to(:get)
      .and respond_to(:list)
      .and respond_to(:update)
  end

  describe '#accounts' do
    describe '#create' do
      it 'returns an Account instance', :vcr do
        account = client.accounts.create(entity_id:, description: 'Test account')

        expect(account)
          .to be_an_instance_of(Fintoc::Transfers::Account)
          .and have_attributes(
            description: 'Test account',
            currency: 'MXN',
            status: 'active'
          )
      end
    end

    describe '#get' do
      it 'returns an Account instance', :vcr do
        account = client.accounts.get(account_id)

        expect(account)
          .to be_an_instance_of(Fintoc::Transfers::Account)
          .and have_attributes(
            id: account_id,
            description: 'Test account'
          )
      end
    end

    describe '#list' do
      it 'returns an array of Account instances', :vcr do
        accounts = client.accounts.list

        expect(accounts).to all(be_a(Fintoc::Transfers::Account))
        expect(accounts.size).to be >= 1
        expect(accounts.first.id).to eq(account_id)
      end
    end

    describe '#update' do
      it 'returns an updated Account instance', :vcr do
        updated_description = 'Updated account description'
        account = client.accounts.update(account_id, description: updated_description)

        expect(account)
          .to be_an_instance_of(Fintoc::Transfers::Account)
          .and have_attributes(
            id: account_id,
            description: updated_description
          )
      end
    end
  end
end
