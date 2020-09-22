require 'fintoc/utils'
RSpec.describe Fintoc::Utils do
  describe '#pick' do
    let(:dict) { {foo: 'Foo', bar: 'Bar', bazz: 'Bazz'} }

    it 'picks a key/value from a given hash' do
      picked = Fintoc::Utils.pick(dict, 'bazz')
      expect(picked).to eq({ bazz: 'Bazz' })
    end

    it 'returns an Empty Hash when the key is not present' do
      picked = Fintoc::Utils.pick(dict, 'blink')
      expect(picked).to eq({})
    end
  end
  describe '#pluralize' do
    let(:single_amount) { 1 }
    let(:amount) { 3 }
    let(:noun) { 'account' }

    it 'adds a plural sufix when the amount is greater than 1' do 
      pluralize = Fintoc::Utils.pluralize(amount, noun)
      expect(pluralize).to eq("#{amount} accounts")
    end

    it 'return the amount in singular when the amount is equals to 1' do 
      pluralize = Fintoc::Utils.pluralize(single_amount, noun)
      expect(pluralize).to eq("#{single_amount} account")
    end
  end
  describe '#snake_to_pascal' do
    let(:pascal_name) { 'this_example_should_be_good_enough' }
    it 'snakefy an pascal string' do
      snaked_name = Fintoc::Utils.snake_to_pascal(pascal_name)
      expect(snaked_name).to eq('ThisExampleShouldBeGoodEnough')
    end
  end
end
