require 'fintoc/resources/institution'

RSpec.describe Fintoc::Institution do
  let(:data) do
    { id: 'cl_banco_de_chile', name: 'Banco de Chile', country: 'cl'}
  end

  let(:institution) { Fintoc::Institution.new(**data)}
  it 'create an instance of Institution' do
    expect(institution).to be_an_instance_of(Fintoc::Institution)
  end
  it "print the institution's name when to_s is called" do
    expect(institution.to_s).to eq("🏦 #{data[:name]}")
  end
end
