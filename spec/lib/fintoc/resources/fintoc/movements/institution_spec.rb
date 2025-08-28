require 'fintoc/resources/movements/institution'

RSpec.describe Fintoc::Movements::Institution do
  let(:data) do
    { id: 'cl_banco_de_chile', name: 'Banco de Chile', country: 'cl' }
  end

  let(:institution) { described_class.new(**data) }

  it 'create an instance of Institution' do
    expect(institution).to be_an_instance_of(described_class)
  end

  it "print the institution's name when to_s is called" do
    expect(institution.to_s).to eq("🏦 #{data[:name]}")
  end
end
