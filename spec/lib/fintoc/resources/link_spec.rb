require 'fintoc/resources/link'
RSpec.describe Fintoc::Link do
  let(:data) do
    {
      "id": 'nMNejK7BT8oGbvO4',
      "username": '183917137',
      "link_token": 'nMNejK7BT8oGbvO4_token_GLtktZX5SKphRtJFe_yJTDWT',
      "holder_type": 'individual',
      "created_at": '2020-04-22T21:10:19.254Z',
      "institution": {
        "country": 'cl',
        "id": 'cl_banco_de_chile',
        "name": 'Banco de Chile'
      },
      "accounts": [
          {
            "id": 'Z6AwnGn4idL7DPj4',
            "name": 'Cuenta Corriente',
            "official_name": 'Cuenta Corriente Moneda Local',
            "number": '9530516286',
            "holder_id": '134910798',
            "holder_name": 'Jon Snow',
            "type": 'checking_account',
            "currency": 'CLP',
            "balance": {
              "available": 7_010_510,
              "current": 7_010_510,
              "limit": 7_510_510
            }
          },
          {
            "id": 'BO381oEATXonG6bj',
            "name": 'Línea de Crédito',
            "official_name": 'Linea De Credito Personas',
            "number": '19534121467',
            "holder_id": '134910798',
            "holder_name": 'Jon Snow',
            "type": 'line_of_credit',
            "currency": 'CLP',
            "balance": {
              "available": 500_000,
              "current": 500_000,
              "limit": 500_000
            }
          }
      ]
    }
  end
  let(:link) { Fintoc::Link.new(**data)}
  it 'create an instance of Link' do
    expect(link).to be_an_instance_of(Fintoc::Link)
  end

  context 'Link #find' do
    it 'returns and valid checking account if the arg is type: "checking_account"' do
      checking_account = link.find(type: 'checking_account')
      data_acc = data[:accounts][0]
      expect(checking_account).to be_an_instance_of(Fintoc::Account)
      expect(checking_account.to_s)
        .to(
          eq("💰 #{data_acc[:holder_name]}’s #{data_acc[:name]} #{data_acc[:balance][:available]} (#{data_acc[:balance][:current]})")
        )
    end
  end
end
