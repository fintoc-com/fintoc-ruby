require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::InstitutionsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_institutions') }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/institution.json'), symbolize_names: true)
  end
  let(:filters) { { country: 'cl', type: 'bank', product: 'movements' } }

  before do
    stub_request(:get, 'https://api.fintoc.com/v1/institutions')
      .with(query: filters)
      .to_return(body: [payload].to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'lists institutions with their products' do
    expect(client.institutions.list(**filters)).to contain_exactly(
      a_kind_of(Fintoc::V1::Institution)
        .and(have_attributes(payload.slice(:id, :name, :country, :type, :products)))
    )
  end
end
