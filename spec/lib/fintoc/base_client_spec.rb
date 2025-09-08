require 'fintoc/base_client'

RSpec.describe Fintoc::BaseClient do
  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { described_class.new(api_key) }

  describe '#initialize' do
    it 'creates an instance with api_key' do
      expect(client).to be_an_instance_of(described_class)
      expect(client.instance_variable_get(:@api_key)).to eq(api_key)
    end

    context 'with jws_private_key' do
      let(:jws_private_key) { OpenSSL::PKey::RSA.new(2048) }
      let(:client_with_jws) { described_class.new(api_key, jws_private_key: jws_private_key) }

      it 'creates an instance with jws support' do
        expect(client_with_jws.instance_variable_get(:@jws)).not_to be_nil
      end
    end
  end

  describe '#get' do
    it 'returns a proc for GET requests' do
      get_request = client.get(version: :v1)
      expect(get_request).to be_a(Proc)
    end
  end

  describe '#delete' do
    it 'returns a proc for DELETE requests' do
      delete_request = client.delete(version: :v1)
      expect(delete_request).to be_a(Proc)
    end
  end

  describe '#post' do
    it 'returns a proc for POST requests' do
      post_request = client.post(version: :v1)
      expect(post_request).to be_a(Proc)
    end
  end

  describe '#patch' do
    it 'returns a proc for PATCH requests' do
      patch_request = client.patch(version: :v1)
      expect(patch_request).to be_a(Proc)
    end
  end

  describe '#request' do
    let(:mock_response) { instance_double(HTTP::Response) }
    let(:mock_status) { instance_double(HTTP::Response::Status) }
    let(:mock_headers) { instance_double(HTTP::Headers) }

    context 'when HTTP request is successful' do
      let(:success_response_body) { { data: 'test_data' }.to_json }

      before do
        allow(mock_response).to receive_messages(
          body: success_response_body,
          status: mock_status,
          headers: mock_headers
        )
        allow(mock_status).to receive_messages(
          client_error?: false,
          server_error?: false
        )
        allow(mock_headers).to receive(:get).with('link').and_return(nil)
        allow(client).to receive(:make_request).and_return(mock_response)
      end

      it 'returns parsed JSON content' do
        request_proc = client.request('get')
        result = request_proc.call('/test/resource')

        expect(result).to eq({ data: 'test_data' })
      end
    end

    context 'when HTTP request returns an error' do
      let(:error_response_body) do
        {
          error: {
            code: 'authentication_error',
            message: 'Invalid API key',
            doc_url: 'https://docs.fintoc.com/errors'
          }
        }.to_json
      end

      before do
        allow(mock_response).to receive_messages(
          body: error_response_body,
          status: mock_status,
          headers: mock_headers
        )
        allow(mock_status).to receive_messages(
          client_error?: true,
          server_error?: false
        )
        allow(mock_headers).to receive(:get).with('link').and_return(nil)
        allow(client).to receive(:make_request).and_return(mock_response)
      end

      it 'raises custom error from response' do
        request_proc = client.request('get')
        expect { request_proc.call('/test/resource') }
          .to raise_error(Fintoc::Errors::AuthenticationError, /Invalid API key/)
      end
    end
  end

  describe '#to_s' do
    it 'returns masked API key representation' do
      result = client.to_s
      expect(result).to include('sk_test_')
      expect(result).to include('****')
      expect(result).not_to include(api_key)
      expect(result).not_to include('SeCreT-aPi_KeY')
    end
  end
end
