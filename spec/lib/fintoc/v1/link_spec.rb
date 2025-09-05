require 'fintoc/v1/resources/link'

RSpec.describe Fintoc::V1::Link do
  let(:data) do
    {
      id: 'nMNejK7BT8oGbvO4',
      username: '183917137',
      link_token: 'nMNejK7BT8oGbvO4_token_GLtktZX5SKphRtJFe_yJTDWT',
      holder_type: 'individual',
      created_at: '2020-04-22T21:10:19.254Z',
      institution: {
        country: 'cl',
        id: 'cl_banco_de_chile',
        name: 'Banco de Chile'
      },
      mode: 'test',
      accounts: [
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
          }
        },
        {
          id: 'BO381oEATXonG6bj',
          name: 'Línea de Crédito',
          official_name: 'Linea De Credito Personas',
          number: '19534121467',
          holder_id: '134910798',
          holder_name: 'Jon Snow',
          type: 'line_of_credit',
          currency: 'CLP',
          refreshed_at: nil,
          balance: {
            available: 500_000,
            current: 500_000,
            limit: 500_000
          }
        }
      ]
    }
  end
  let(:link) { described_class.new(**data, client:) }
  let(:client) { Fintoc::V1::Client.new(api_key) }
  let(:api_key) { 'sk_test_SeCrEt_aPi_KeY' }

  describe '#new' do
    it 'create an instance of Link' do
      expect(link).to be_an_instance_of(described_class)
    end
  end

  describe '#to_s' do
    it 'returns the link as a string' do
      expect(link.to_s).to eq("<#{data[:username]}@#{data[:institution][:name]}> 🔗 <Fintoc>")
    end
  end

  describe '#find' do
    it 'returns and valid checking account if the arg is type: "checking_account"' do
      checking_account = link.find(type: 'checking_account')
      data_acc = data[:accounts][0]
      expect(checking_account).to be_an_instance_of(Fintoc::V1::Account)
      expect(checking_account.to_s)
        .to(
          eq(
            "💰 #{data_acc[:holder_name]}’s #{data_acc[:name]} #{data_acc[:balance][:available]} " \
            "(#{data_acc[:balance][:current]})"
          )
        )
    end
  end

  describe '#show_accounts' do
    context 'when link has accounts' do
      it 'displays accounts information' do
        expect { link.show_accounts }.to output(/This links has 2 accounts/).to_stdout
      end
    end

    context 'when link has no accounts' do
      it 'displays zero accounts message' do
        empty_link = described_class.new(**data, accounts: [])
        expect { empty_link.show_accounts }.to output(/This links has 0 accounts/).to_stdout
      end
    end
  end

  describe '#update_accounts' do
    let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
    let(:client) { Fintoc::V1::Client.new(api_key) }
    let(:link_token) { '6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W' }
    let(:linked_link) { client.links.get(link_token) }
    let(:account_original_balance) do
      {
        available: 7_010_510,
        current: 7_010_510,
        limit: 7_510_510
      }
    end
    let(:account_data_before_update) do
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
        balance: account_original_balance
      }
    end

    let(:data) do
      {
        id: 'nMNejK7BT8oGbvO4',
        username: '183917137',
        link_token: 'nMNejK7BT8oGbvO4_token_GLtktZX5SKphRtJFe_yJTDWT',
        holder_type: 'individual',
        created_at: '2020-04-22T21:10:19.254Z',
        institution: {
          country: 'cl',
          id: 'cl_banco_de_chile',
          name: 'Banco de Chile'
        },
        mode: 'test',
        accounts: [account_data_before_update]
      }
    end

    it 'updates balance and movements for all accounts', :vcr do
      expect(link.accounts[0].balance.available).to eq(account_original_balance[:available])
      link.update_accounts
      expect(link.accounts[0].balance).to be_a(Fintoc::V1::Balance)
      expect(link.accounts[0].balance.available).not_to eq(account_original_balance[:available])
    end
  end

  describe '#delete' do
    let(:delete_proc) { instance_double(Proc) }

    before do
      allow(client).to receive(:delete).with(version: :v1).and_return(delete_proc)
      allow(delete_proc)
        .to receive(:call)
        .with("links/#{link.id}")
        .and_return(true)
    end

    it 'deletes the link successfully' do
      expect(link.delete).to be true
    end
  end
end
