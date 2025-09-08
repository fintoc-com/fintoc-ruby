require 'fintoc/v1/managers/links_manager'

RSpec.describe Fintoc::V1::Managers::LinksManager do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:client) { Fintoc::V1::Client.new(api_key) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:delete_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:link_id) { 'link_123' }
  let(:link_token) { '6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W' }
  let(:first_link_data) do
    {
      id: link_id,
      object: 'link',
      link_token: link_token
    }
  end
  let(:second_link_data) do
    {
      id: 'link_456',
      object: 'link',
      link_token: link_token
    }
  end

  before do
    allow(client).to receive(:get).with(version: :v1).and_return(get_proc)
    allow(client).to receive(:post).with(version: :v1).and_return(post_proc)
    allow(client).to receive(:delete).with(version: :v1).and_return(delete_proc)

    allow(get_proc)
      .to receive(:call)
      .with("links/#{link_token}")
      .and_return(first_link_data)
    allow(get_proc)
      .to receive(:call)
      .with('links')
      .and_return([first_link_data, second_link_data])
    allow(post_proc)
      .to receive(:call)
      .with('links', link_token:)
      .and_return(first_link_data)
    allow(delete_proc)
      .to receive(:call)
      .with("links/#{link_id}")
      .and_return(true)

    allow(Fintoc::V1::Link).to receive(:new)
  end

  describe '#links' do
    describe '#get' do
      it 'calls build_link with the response' do
        manager.get(link_token)
        expect(Fintoc::V1::Link)
          .to have_received(:new).with(**first_link_data, client:)
      end
    end

    describe '#list' do
      it 'calls build_link with the response' do
        manager.list
        expect(Fintoc::V1::Link)
          .to have_received(:new).with(**first_link_data, client:)
        expect(Fintoc::V1::Link)
          .to have_received(:new).with(**second_link_data, client:)
      end
    end

    describe '#delete' do
      it 'calls build_link with the response' do
        expect(manager.delete(link_id)).to be true
      end
    end
  end
end
