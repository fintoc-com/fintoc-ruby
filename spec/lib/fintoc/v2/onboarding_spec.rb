require 'fintoc/v2/resources/onboarding'

RSpec.describe Fintoc::V2::Onboarding do
  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { Fintoc::V2::Client.new(api_key) }

  let(:shareholder_data) do
    {
      id: 'onbsh_123',
      object: 'onboarding_shareholder',
      type: 'natural_person',
      name: 'Jane',
      last_name: 'Doe',
      percentage: 60,
      holder_id: '12345678-9',
      parent_id: nil,
      document: { slot_key: 'shareholder_id', status: 'missing' }
    }
  end

  let(:document_data) do
    {
      slot_key: 'incorporation_certificate',
      status: 'uploaded',
      filename: 'cert.pdf',
      uploaded_at: '2026-06-22T00:00:00Z'
    }
  end

  let(:data) do
    {
      id: 'onbprc_0ujs',
      object: 'onboarding',
      entity_id: 'ent_12345',
      status: 'in_progress',
      source: 'api',
      submitted_at: nil,
      reviewed_at: nil,
      submittable: false,
      data: { company_information: { legal_name: 'ACME Inc.' } },
      shareholders: [shareholder_data],
      documents: [document_data],
      client: client
    }
  end

  let(:onboarding) { described_class.new(**data) }

  describe '#new' do
    it 'creates an instance of Onboarding' do
      expect(onboarding).to be_an_instance_of(described_class)
    end

    it 'sets all attributes correctly' do # rubocop:disable RSpec/ExampleLength
      expect(onboarding).to have_attributes(
        id: 'onbprc_0ujs',
        object: 'onboarding',
        entity_id: 'ent_12345',
        status: 'in_progress',
        source: 'api',
        submitted_at: nil,
        reviewed_at: nil,
        submittable: false,
        data: { company_information: { legal_name: 'ACME Inc.' } },
        shareholders: [shareholder_data],
        documents: [document_data]
      )
    end

    it 'keeps shareholders as raw hashes' do
      expect(onboarding.shareholders.first).to eq(shareholder_data)
    end

    it 'keeps documents as raw hashes' do
      expect(onboarding.documents.first).to eq(document_data)
    end
  end

  describe 'light shape' do
    let(:light_data) do
      {
        id: 'onbprc_0ujs',
        object: 'onboarding',
        entity_id: 'ent_12345',
        status: 'pending',
        source: 'dashboard',
        submitted_at: nil,
        reviewed_at: nil
      }
    end

    let(:light_onboarding) { described_class.new(**light_data) }

    it 'builds without full attributes' do
      expect(light_onboarding).to have_attributes(
        id: 'onbprc_0ujs',
        status: 'pending',
        source: 'dashboard',
        submittable: nil,
        data: nil,
        shareholders: nil,
        documents: nil
      )
    end
  end

  describe '#to_s' do
    it 'returns a formatted string representation' do
      expect(onboarding.to_s).to eq('📋 Onboarding onbprc_0ujs (in_progress)')
    end
  end
end
