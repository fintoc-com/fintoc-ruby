RSpec.shared_examples 'a client with account numbers methods' do
  let(:account_number_id) { 'acno_326dzRGqxLee3j9TkaBBBMfs2i0' }
  let(:account_id) { 'acc_31yYL7h9LVPg121AgFtCyJPDsgM' }

  it 'responds to account number-specific methods' do
    expect(client)
      .to respond_to(:create_account_number)
      .and respond_to(:get_account_number)
      .and respond_to(:list_account_numbers)
      .and respond_to(:update_account_number)
  end

  describe '#create_account_number' do
    it 'returns an AccountNumber instance', :vcr do
      account_number = client.create_account_number(
        account_id:, description: 'Test account number', metadata: { test_id: '12345' }
      )

      expect(account_number)
        .to be_an_instance_of(Fintoc::Transfers::AccountNumber)
        .and have_attributes(
          account_id:,
          description: 'Test account number',
          object: 'account_number'
        )
    end
  end

  describe '#get_account_number' do
    it 'returns an AccountNumber instance', :vcr do
      account_number = client.get_account_number(account_number_id)

      expect(account_number)
        .to be_an_instance_of(Fintoc::Transfers::AccountNumber)
        .and have_attributes(
          id: account_number_id,
          object: 'account_number'
        )
    end
  end

  describe '#list_account_numbers' do
    it 'returns an array of AccountNumber instances', :vcr do
      account_numbers = client.list_account_numbers

      expect(account_numbers).to all(be_a(Fintoc::Transfers::AccountNumber))
      expect(account_numbers.size).to be >= 1
      expect(account_numbers.first.id).to eq(account_number_id)
    end
  end

  describe '#update_account_number' do
    it 'returns an updated AccountNumber instance', :vcr do
      updated_description = 'Updated account number description'
      account_number = client.update_account_number(
        account_number_id, description: updated_description
      )

      expect(account_number)
        .to be_an_instance_of(Fintoc::Transfers::AccountNumber)
        .and have_attributes(
          id: account_number_id,
          description: updated_description
        )
    end
  end
end
