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

    context 'when use_jws parameter is provided' do
      before do
        allow(client)
          .to receive(:request).with('post', version: :v1, use_jws: true, idempotency_key: nil)
      end

      it 'passes use_jws parameter to request' do
        client.post(version: :v1, use_jws: true)
        expect(client)
          .to have_received(:request)
          .with('post', version: :v1, use_jws: true, idempotency_key: nil)
      end
    end

    context 'when idempotency_key parameter is provided' do
      let(:idempotency_key) { SecureRandom.uuid }

      before do
        allow(client)
          .to receive(:request).with('post', version: :v1, use_jws: false, idempotency_key:)
      end

      it 'passes idempotency_key parameter to request' do
        client.post(version: :v1, idempotency_key:)
        expect(client)
          .to have_received(:request).with('post', version: :v1, use_jws: false, idempotency_key:)
      end
    end

    context 'when both use_jws and idempotency_key parameters are provided' do
      let(:idempotency_key) { SecureRandom.uuid }

      before do
        allow(client)
          .to receive(:request).with('post', version: :v1, use_jws: true, idempotency_key:)
      end

      it 'passes both use_jws and idempotency_key parameters to request' do
        client.post(version: :v1, use_jws: true, idempotency_key:)
        expect(client)
          .to have_received(:request).with('post', version: :v1, use_jws: true, idempotency_key:)
      end
    end
  end

  describe '#patch' do
    it 'returns a proc for PATCH requests' do
      patch_request = client.patch(version: :v1)
      expect(patch_request).to be_a(Proc)
    end

    context 'when use_jws parameter is provided' do
      before do
        allow(client)
          .to receive(:request).with('patch', version: :v1, use_jws: true, idempotency_key: nil)
      end

      it 'passes use_jws parameter to request' do
        client.patch(version: :v1, use_jws: true)
        expect(client)
          .to have_received(:request)
          .with('patch', version: :v1, use_jws: true, idempotency_key: nil)
      end
    end

    context 'when idempotency_key parameter is provided' do
      let(:idempotency_key) { SecureRandom.uuid }

      before do
        allow(client)
          .to receive(:request).with('patch', version: :v1, use_jws: false, idempotency_key:)
      end

      it 'passes idempotency_key parameter to request' do
        client.patch(version: :v1, idempotency_key:)
        expect(client)
          .to have_received(:request)
          .with('patch', version: :v1, use_jws: false, idempotency_key:)
      end
    end

    context 'when both use_jws and idempotency_key parameters are provided' do
      let(:idempotency_key) { SecureRandom.uuid }

      before do
        allow(client)
          .to receive(:request).with('patch', version: :v1, use_jws: true, idempotency_key:)
      end

      it 'passes both use_jws and idempotency_key parameters to request' do
        client.patch(version: :v1, use_jws: true, idempotency_key:)
        expect(client)
          .to have_received(:request)
          .with('patch', version: :v1, use_jws: true, idempotency_key:)
      end
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
        result = request_proc.call('test/resource')

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
        expect { request_proc.call('test/resource') }
          .to raise_error(Fintoc::Errors::AuthenticationError, /Invalid API key/)
      end
    end

    context 'when idempotency_key is provided' do
      let(:success_response_body) { { data: 'test_data' }.to_json }
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }
      let(:mock_http_client) { instance_double(HTTP::Client) }

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

        allow(client).to receive(:make_request).and_call_original
        allow(client).to receive(:client).and_return(mock_http_client)
        allow(mock_http_client).to receive_messages(headers: mock_http_client, send: mock_response)
      end

      it 'passes idempotency_key on POST request headers' do
        client.request('post', idempotency_key:).call('test/resource', data: 'test')

        expect(mock_http_client)
          .to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end

      it 'passes idempotency_key on PATCH request headers' do
        client.request('patch', idempotency_key:).call('test/resource', data: 'test')

        expect(mock_http_client)
          .to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end

      it 'does not pass idempotency_key on GET request headers' do
        client.request('get').call('test/resource', param: 'value')

        expect(mock_http_client)
          .not_to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end

      it 'does not pass idempotency_key on DELETE request headers' do
        client.request('delete').call('test/resource', param: 'value')

        expect(mock_http_client)
          .not_to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end
    end
  end

  describe '#make_request' do
    let(:mock_http_client) { instance_double(HTTP::Client) }
    let(:mock_response) { instance_double(HTTP::Response) }

    before do
      allow(client).to receive(:client).and_return(mock_http_client)
      allow(mock_http_client).to receive_messages(
        headers: mock_http_client,
        send: mock_response
      )
    end

    context 'when idempotency_key is provided for supported methods' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      it 'adds Idempotency-Key header for POST requests' do
        client.send(:make_request, 'post', '/test', {}, idempotency_key: idempotency_key)

        expect(mock_http_client)
          .to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end

      it 'adds Idempotency-Key header for PATCH requests' do
        client.send(:make_request, 'patch', '/test', {}, idempotency_key: idempotency_key)

        expect(mock_http_client)
          .to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end

      it 'adds Idempotency-Key header for PUT requests' do
        client.send(:make_request, 'put', '/test', {}, idempotency_key: idempotency_key)

        expect(mock_http_client)
          .to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end
    end

    context 'when idempotency_key is provided for unsupported methods' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      it 'does not add Idempotency-Key header' do
        client.send(:make_request, 'get', '/test', {}, idempotency_key: idempotency_key)

        expect(mock_http_client)
          .not_to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end

      it 'does not add Idempotency-Key header for DELETE requests' do
        client.send(:make_request, 'delete', '/test', {}, idempotency_key: idempotency_key)

        expect(mock_http_client)
          .not_to have_received(:headers).with('Idempotency-Key' => idempotency_key)
      end
    end

    context 'when no idempotency_key is provided' do
      it 'does not add Idempotency-Key header' do
        client.send(:make_request, 'post', '/test', {})

        expect(mock_http_client)
          .not_to have_received(:headers).with(hash_including('Idempotency-Key'))
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
