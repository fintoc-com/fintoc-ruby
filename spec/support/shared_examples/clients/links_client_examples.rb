RSpec.shared_examples 'a client with links manager' do
  let(:link_token) { '6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W' }

  it 'responds to link-specific methods' do
    expect(client).to respond_to(:links)
    expect(client.links).to be_a(Fintoc::Movements::Managers::LinksManager)
    expect(client.links)
      .to respond_to(:get)
      .and respond_to(:list)
      .and respond_to(:delete)
  end

  describe '#links' do
    describe '#get' do
      it 'get the link from a given link token', :vcr do
        link = client.links.get(link_token)
        expect(link).to be_an_instance_of(Fintoc::Movements::Link)
      end
    end

    describe '#list' do
      it 'get all the links from a given link token', :vcr do
        links = client.links.list
        expect(links).to all(be_a(Fintoc::Movements::Link))
      end
    end
  end
end
