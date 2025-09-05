require 'fintoc/v1/resources/balance'

RSpec.describe Fintoc::V1::Balance do
  let(:data) { { available: 1000, current: 500, limit: 10 } }
  let(:balance) { described_class.new(**data) }

  describe '#new' do
    it 'create an instance of Balance' do
      expect(balance).to be_an_instance_of(described_class)
    end

    it 'returns their object_id when id_ getter is called' do
      expect(balance.id).to eq(balance.object_id)
    end
  end

  describe '#to_s' do
    it 'returns the balance as a string' do
      expect(balance.to_s).to eq('1000 (500)')
    end
  end

  describe '#inspect' do
    it 'returns the balance as a string' do
      expect(balance.inspect)
        .to eq("<Fintoc::V1::Balance #{data[:available]} (#{data[:current]})>")
    end
  end
end
