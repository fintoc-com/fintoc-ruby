RSpec.shared_examples 'a client with links methods' do
  let(:link_token) { '6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W' }

  it 'responds to link-specific methods' do
    expect(client)
      .to respond_to(:get_link)
      .and respond_to(:get_links)
      .and respond_to(:delete_link)
      .and respond_to(:get_account)
  end

  describe '#get_link' do
    it 'get the link from a given link token', :vcr do
      link = client.get_link(link_token)
      expect(link).to be_an_instance_of(Fintoc::Movements::Link)
    end
  end

  describe '#get_links' do
    it 'get all the links from a given link token', :vcr do
      links = client.get_links
      expect(links).to all(be_a(Fintoc::Movements::Link))
    end
  end

  describe '#get_account' do
    it 'get a linked account', :vcr do
      link = client.get_link(link_token)
      account = link.find(type: 'checking_account')
      returned_account = client.get_account(link_token, account.id)
      expect(returned_account).to be_an_instance_of(Fintoc::Movements::Account)
    end
  end

  describe '#get_accounts', :vcr do
    it 'prints accounts to console' do
      link = client.get_link(link_token)
      expect do
        link.show_accounts
      end.to output(start_with('This links has 1 account')).to_stdout
    end
  end
end
