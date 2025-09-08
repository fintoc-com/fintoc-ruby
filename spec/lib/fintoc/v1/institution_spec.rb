require 'fintoc/v1/resources/institution'

RSpec.describe Fintoc::V1::Institution do
  let(:data) do
    { id: 'cl_banco_de_chile', name: 'Banco de Chile', country: 'cl' }
  end

  let(:institution) { described_class.new(**data) }

  describe '#new' do
    it 'create an instance of Institution' do
      expect(institution).to be_an_instance_of(described_class)
    end
  end

  describe '#to_s' do
    it "print the institution's name when to_s is called" do
      expect(institution.to_s).to eq("🏦 #{data[:name]}")
    end
  end

  describe '#inspect' do
    it 'returns the institution as a string' do
      expect(institution.inspect).to eq("<Fintoc::V1::Institution #{data[:name]}>")
    end
  end
end
