require 'base64'
require 'json'
require 'openssl'
require 'webmock/rspec'
require 'fintoc/client'

RSpec.describe Fintoc::V1::Managers::OrganizationsManager do
  let(:jws_private_key) { OpenSSL::PKey::RSA.new(2048) }
  let(:manager) { Fintoc::Client.new('sk_live_organizations', jws_private_key:).v1.organizations }
  let(:collection_url) { 'https://api.fintoc.com/v1/organizations' }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/organization.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  def signed?(request)
    protected_b64, signature_b64 = request.headers['Fintoc-Jws-Signature'].split('.')
    payload_b64 = Base64.urlsafe_encode64(request.body, padding: false)
    jws_private_key.public_key.verify(
      OpenSSL::Digest.new('SHA256'), Base64.urlsafe_decode64(signature_b64),
      "#{protected_b64}.#{payload_b64}"
    )
  end

  describe '#create' do
    let(:params) do
      {
        name: 'Empresa SpA',
        tax_id: '11.111.111-1',
        founder_email: 'jared@piedpiper.com',
        products: {
          business_accounts: {
            company_basics: { incorporation_type: 'one_day_company' },
            shareholders: [{ type: 'legal_entity', name: 'Test Company 2 SpA', percentage: 40 }]
          }
        },
        external_reference: 'SOL-123',
        metadata: { request_id: 'abc' }
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params.to_json) { |request| signed?(request) }
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'signs the body and returns the organization' do
      expect(manager.create(**params))
        .to be_a(Fintoc::V1::Organization).and have_attributes(payload)
    end

    context 'when the tax_id belongs to another organization' do
      before do
        error = { error: { type: 'conflicted_request_error', code: 'organization_already_exists',
                           message: 'An organization with this tax_id already exists' } }
        stub_request(:post, collection_url)
          .to_return(status: 409, body: error.to_json, headers: headers)
      end

      it 'raises OrganizationAlreadyExistsError' do
        expect { manager.create(**params) }
          .to raise_error(Fintoc::Errors::OrganizationAlreadyExistsError)
      end
    end
  end
end
