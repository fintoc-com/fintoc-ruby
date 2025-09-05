RSpec.shared_examples 'a client with account numbers manager' do
  let(:account_number_id) { 'acno_326dzRGqxLee3j9TkaBBBMfs2i0' }
  let(:account_id) { 'acc_31yYL7h9LVPg121AgFtCyJPDsgM' }

  it 'responds to account number-specific methods' do
    expect(client).to respond_to(:account_numbers)
    expect(client.account_numbers).to be_a(Fintoc::V2::Managers::AccountNumbersManager)
    expect(client.account_numbers)
      .to respond_to(:create)
      .and respond_to(:get)
      .and respond_to(:list)
      .and respond_to(:update)
  end

  describe '#account_numbers' do
    describe '#create' do
      it 'returns an AccountNumber instance', :vcr do
        account_number = client.account_numbers.create(
          account_id:, description: 'Test account number', metadata: { test_id: '12345' }
        )

        expect(account_number)
          .to be_an_instance_of(Fintoc::V2::AccountNumber)
          .and have_attributes(
            account_id:,
            description: 'Test account number',
            object: 'account_number'
          )
      end
    end

    describe '#get' do
      it 'returns an AccountNumber instance', :vcr do
        account_number = client.account_numbers.get(account_number_id)

        expect(account_number)
          .to be_an_instance_of(Fintoc::V2::AccountNumber)
          .and have_attributes(
            id: account_number_id,
            object: 'account_number'
          )
      end
    end

    describe '#list' do
      it 'returns an array of AccountNumber instances', :vcr do
        account_numbers = client.account_numbers.list

        expect(account_numbers).to all(be_a(Fintoc::V2::AccountNumber))
        expect(account_numbers.size).to be >= 1
        expect(account_numbers.first.id).to eq(account_number_id)
      end
    end

    describe '#update' do
      it 'returns an updated AccountNumber instance', :vcr do
        updated_description = 'Updated account number description'
        account_number = client.account_numbers.update(
          account_number_id, description: updated_description
        )

        expect(account_number)
          .to be_an_instance_of(Fintoc::V2::AccountNumber)
          .and have_attributes(
            id: account_number_id,
            description: updated_description
          )
      end
    end
  end
end
