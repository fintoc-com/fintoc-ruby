require 'json'
require 'openssl'
require 'webmock/rspec'
require 'fintoc/client'

RSpec.describe Fintoc::V1::Managers::OrganizationsManager do
  let(:jws_private_key) { OpenSSL::PKey::RSA.new(2048) }
  let(:manager) { Fintoc::Client.new('sk_live_organizations', jws_private_key:).v1.organizations }
  let(:collection_url) { 'https://api.fintoc.com/v1/organizations' }
  let(:organization_id) { 'org_0ujsswThIGTUYm2K8FjOOfXtY1K' }
  let(:resource_url) { "#{collection_url}/#{organization_id}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/organization.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  def unsigned?(request)
    !request.headers.key?('Fintoc-Jws-Signature')
  end

  def stub_error(method, url, status:, type:, code:)
    error = { error: { type:, code:, message: 'error' } }
    stub_request(method, url).to_return(status:, body: error.to_json, headers:)
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
        .with(body: params.to_json) { |request| unsigned?(request) }
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'sends the body without a JWS signature and returns the organization' do
      expect(manager.create(**params))
        .to be_a(Fintoc::V1::Organization).and have_attributes(payload)
    end

    context 'when the tax_id belongs to another organization' do
      before do
        stub_error(:post, collection_url, status: 409, type: 'conflicted_request_error',
                                          code: 'organization_already_exists')
      end

      it 'raises OrganizationAlreadyExistsError' do
        expect { manager.create(**params) }
          .to raise_error(Fintoc::Errors::OrganizationAlreadyExistsError)
      end
    end
  end

  describe '#update' do
    let(:params) do
      { founder_email: 'richard@piedpiper.com', previous_founder_email: 'jared@piedpiper.com' }
    end

    before do
      stub_request(:patch, resource_url)
        .with(body: params.to_json) { |request| unsigned?(request) }
        .to_return(status: 200, body: payload.to_json, headers: headers)
    end

    it 'replaces the founder email and returns the organization' do
      expect(manager.update(organization_id, **params))
        .to be_a(Fintoc::V1::Organization).and have_attributes(payload)
    end

    {
      [404, 'invalid_request_error', 'founder_email_mismatch'] =>
        Fintoc::Errors::FounderEmailMismatchError,
      [409, 'conflicted_request_error', 'founder_already_activated'] =>
        Fintoc::Errors::FounderAlreadyActivatedError,
      [422, 'invalid_request_error', 'founder_email_change_limit_reached'] =>
        Fintoc::Errors::FounderEmailChangeLimitReachedError
    }.each do |(status, type, code), error_class|
      context "when the API responds #{code}" do
        before { stub_error(:patch, resource_url, status:, type:, code:) }

        it "raises #{error_class.name.split('::').last}" do
          expect { manager.update(organization_id, **params) }.to raise_error(error_class)
        end
      end
    end
  end
end
