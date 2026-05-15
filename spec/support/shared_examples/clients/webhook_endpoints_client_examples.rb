RSpec.shared_examples 'a client with webhook endpoints manager' do
  it 'responds to webhook_endpoints-specific methods' do
    expect(client).to respond_to(:webhook_endpoints)
    expect(client.webhook_endpoints).to be_a(Fintoc::V1::Managers::WebhookEndpointsManager)
    expect(client.webhook_endpoints)
      .to respond_to(:create)
      .and respond_to(:get)
      .and respond_to(:list)
      .and respond_to(:update)
      .and respond_to(:delete)
      .and respond_to(:test)
  end
end
