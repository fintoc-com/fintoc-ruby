require 'fintoc/movements/resources/account'

RSpec.describe Fintoc::Movements::Account do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:client) { Fintoc::Movements::Client.new(api_key) }

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
      expect(movements).to all(be_a(Fintoc::Movements::Movement))
    end
  end

  describe '#movement with since argument' do
    it "get account's movements with arguments", :vcr do
      movements = linked_account.get_movements(since: '2020-08-15')
      linked_account.show_movements
      expect(movements).to all(be_a(Fintoc::Movements::Movement))
    end
  end

  describe '#update_balance' do
    it "update account's movements", :vcr do
      movements = linked_account.update_movements
      expect(movements).to all(be_a(Fintoc::Movements::Movement))
    end
  end
end
