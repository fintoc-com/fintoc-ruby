require 'fintoc/v1/resources/account'

RSpec.describe Fintoc::V1::Account do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:client) { Fintoc::V1::Client.new(api_key) }

  let(:data) do
    {
      id: 'Z6AwnGn4idL7DPj4',
      name: 'Cuenta Corriente',
      official_name: 'Cuenta Corriente Moneda Local',
      number: '9530516286',
      holder_id: '134910798',
      holder_name: 'Jon Snow',
      type: 'checking_account',
      currency: 'CLP',
      refreshed_at: nil,
      balance: {
        available: 7_010_510,
        current: 7_010_510,
        limit: 7_510_510
      },
      client: client
    }
  end

  let(:link_token) { '6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W' }
  let(:link) { client.links.get(link_token) }
  let(:account) { described_class.new(**data) }
  let(:linked_account) { link.find(type: 'checking_account') }

  describe '#new' do
    it 'create an instance of Account' do
      expect(account).to be_an_instance_of(described_class)
    end
  end

  describe '#to_s' do
    it "print the account's holder_name, name, and balance when to_s is called" do
      expect(account.to_s)
        .to eq(
          "💰 #{data[:holder_name]}’s #{data[:name]} #{data[:balance][:available]} " \
          "(#{data[:balance][:current]})"
        )
    end
  end

  describe '#get_movements' do
    it "get the last 30 account's movements", :vcr do
      movements = linked_account.get_movements
      expect(movements.size).to be <= 30
      expect(movements).to all(be_a(Fintoc::V1::Movement))
    end
  end

  describe '#movement with since argument' do
    it "get account's movements with arguments", :vcr do
      movements = linked_account.get_movements(since: '2020-08-15')
      linked_account.show_movements
      expect(movements).to all(be_a(Fintoc::V1::Movement))
    end
  end

  describe '#show_movements' do
    context 'when account has movements' do
      let(:movement) do
        Fintoc::V1::Movement.new(
          id: '1',
          amount: 1000,
          currency: 'CLP',
          description: 'Test movement',
          post_date: '2023-01-01T10:00:00Z',
          transaction_date: '2023-01-01T10:00:00Z',
          type: 'normal_movement',
          reference_id: 'ref123',
          recipient_account: nil,
          sender_account: nil,
          comment: nil
        )
      end

      let(:account) { described_class.new(**data, movements: [movement]) }

      it 'displays movements information with non-empty movements array' do
        expect { account.show_movements }.to output(/This account has 1 movement/).to_stdout
      end
    end

    context 'when account has no movements' do
      let(:account) { described_class.new(**data, movements: []) }

      it 'displays zero movements message' do
        expect { account.show_movements }.to output(/This account has 0 movements/).to_stdout
      end
    end
  end

  describe '#update_balance' do
    let(:client_for_update_balance) { Fintoc::V1::Client.new(api_key) }

    it "updates the account's balance", :vcr do
      initial_balance = account.balance
      account.update_balance
      expect(account.balance).to be_a(Fintoc::V1::Balance)
      expect(account.balance).not_to equal(initial_balance)
    end
  end

  describe '#update_movements' do
    it "update account's movements", :vcr do
      movements = linked_account.update_movements
      expect(movements).to all(be_a(Fintoc::V1::Movement))
    end
  end
end
