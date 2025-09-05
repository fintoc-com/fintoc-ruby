RSpec.describe Fintoc, :module do
  it 'is a valid version number' do
    expect(Fintoc::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
