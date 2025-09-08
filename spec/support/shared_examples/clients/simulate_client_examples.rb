RSpec.shared_examples 'a client with simulate manager' do
  it 'responds to simulate-specific methods' do
    expect(client).to respond_to(:simulate)
    expect(client.simulate).to be_a(Fintoc::V2::Managers::SimulateManager)
    expect(client.simulate)
      .to respond_to(:receive_transfer)
  end

  describe '#simulate' do
    describe '#receive_transfer' do
      let(:simulate_transfer_data) do
        {
          account_number_id: 'acno_326dzRGqxLee3j9TkaBBBMfs2i0',
          amount: 10000,
          currency: 'MXN'
        }
      end

      it 'simulates receiving a transfer and returns Transfer object', :vcr do
        transfer = client.simulate.receive_transfer(**simulate_transfer_data)

        expect(transfer)
          .to be_an_instance_of(Fintoc::V2::Transfer)
          .and have_attributes(
            amount: simulate_transfer_data[:amount],
            currency: simulate_transfer_data[:currency],
            account_number: include(id: simulate_transfer_data[:account_number_id])
          )
      end
    end
  end
end
