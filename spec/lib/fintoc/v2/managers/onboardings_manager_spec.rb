require 'fintoc/v2/managers/onboardings_manager'

RSpec.describe Fintoc::V2::Managers::OnboardingsManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:put_proc) { instance_double(Proc) }
  let(:entity_id) { 'ent_12345' }
  let(:onboarding_id) { 'onbprc_0ujs' }
  let(:shareholder_id) { 'onbsh_123' }
  let(:legal_representative_id) { 'onblr_123' }
  let(:base_path) { "entities/#{entity_id}/onboardings" }
  let(:manager) { described_class.new(client, entity_id) }

  let(:first_onboarding_data) do
    {
      id: onboarding_id,
      object: 'onboarding',
      entity_id: entity_id,
      type: 'account_holder',
      status: 'in_progress',
      source: 'api',
      submitted_at: nil,
      reviewed_at: nil
    }
  end

  let(:second_onboarding_data) do
    {
      id: 'onbprc_other',
      object: 'onboarding',
      entity_id: entity_id,
      type: 'settlement_recipient',
      status: 'submitted',
      source: 'dashboard',
      submitted_at: '2026-06-22T00:00:00Z',
      reviewed_at: nil
    }
  end

  let(:full_onboarding_data) do
    first_onboarding_data.merge(
      submittable: true,
      data: {},
      legal_representatives: [],
      shareholders: [],
      documents: []
    )
  end

  let(:create_params) do
    {
      type: 'account_holder',
      data: {
        company_information: { business_activity: 'Servicios financieros' },
        legal_representatives: [{ first_name: 'Jane', last_name: 'Doe' }],
        transactional_profile: { monthly_amount_range: '1_500000' },
        shareholders: [{ type: 'natural_person', name: 'Jane', percentage: 100 }]
      }
    }
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)
    allow(client).to receive(:post).with(version: :v2, idempotency_key: nil).and_return(post_proc)
    allow(client).to receive(:put).with(version: :v2, idempotency_key: nil).and_return(put_proc)

    allow(get_proc)
      .to receive(:call)
      .with(base_path)
      .and_return([first_onboarding_data, second_onboarding_data])
    allow(get_proc)
      .to receive(:call)
      .with("#{base_path}/#{onboarding_id}")
      .and_return(full_onboarding_data)
    allow(post_proc)
      .to receive(:call)
      .with(base_path, **create_params)
      .and_return(full_onboarding_data)
    allow(post_proc)
      .to receive(:call)
      .with("#{base_path}/#{onboarding_id}/submit")
      .and_return(full_onboarding_data)
    allow(put_proc).to receive(:call).and_return(full_onboarding_data)

    allow(Fintoc::V2::Onboarding).to receive(:new)
  end

  describe '#list' do
    it 'fetches and builds onboardings (light shape)' do
      manager.list

      expect(get_proc).to have_received(:call).with(base_path)
      expect(Fintoc::V2::Onboarding).to have_received(:new).with(**first_onboarding_data, client:)
      expect(Fintoc::V2::Onboarding).to have_received(:new).with(**second_onboarding_data, client:)
    end

    it 'passes parameters to the API call' do
      params = { per_page: 50 }
      allow(get_proc).to receive(:call).with(base_path, **params).and_return([])

      manager.list(**params)

      expect(get_proc).to have_received(:call).with(base_path, **params)
    end
  end

  describe '#get' do
    it 'fetches and builds a full onboarding' do
      manager.get(onboarding_id)

      expect(get_proc).to have_received(:call).with("#{base_path}/#{onboarding_id}")
      expect(Fintoc::V2::Onboarding).to have_received(:new).with(**full_onboarding_data, client:)
    end
  end

  describe '#create' do
    it 'forwards the nested structures as JSON and builds the onboarding' do
      manager.create(**create_params)

      expect(post_proc).to have_received(:call).with(base_path, **create_params)
      expect(Fintoc::V2::Onboarding).to have_received(:new).with(**full_onboarding_data, client:)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client).to receive(:post).with(version: :v2, idempotency_key:).and_return(post_proc)
        allow(post_proc).to receive(:call).with(base_path, **create_params)
                                          .and_return(full_onboarding_data)
      end

      it 'passes idempotency_key to the POST method' do
        manager.create(idempotency_key:, **create_params)

        expect(client).to have_received(:post).with(version: :v2, idempotency_key:)
      end
    end
  end

  describe '#submit' do
    it 'posts to the submit path without a body and builds the onboarding' do
      manager.submit(onboarding_id)

      expect(post_proc).to have_received(:call).with("#{base_path}/#{onboarding_id}/submit")
      expect(Fintoc::V2::Onboarding).to have_received(:new).with(**full_onboarding_data, client:)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client).to receive(:post).with(version: :v2, idempotency_key:).and_return(post_proc)
        allow(post_proc).to receive(:call).with("#{base_path}/#{onboarding_id}/submit")
                                          .and_return(full_onboarding_data)
      end

      it 'passes idempotency_key to the POST method' do
        manager.submit(onboarding_id, idempotency_key:)

        expect(client).to have_received(:post).with(version: :v2, idempotency_key:)
      end
    end
  end

  describe '#upload_document' do
    let(:slot_key) { 'incorporation_certificate' }
    let(:file_path) { 'spec/support/fixtures/sample_document.pdf' }

    it 'puts a multipart file to the document slot path' do
      manager.upload_document(onboarding_id, slot_key, file: file_path)

      expect(client).to have_received(:put).with(version: :v2, idempotency_key: nil)
      expect(put_proc).to have_received(:call).with(
        "#{base_path}/#{onboarding_id}/documents/#{slot_key}",
        form: { file: file_path }
      )
      expect(Fintoc::V2::Onboarding).to have_received(:new).with(**full_onboarding_data, client:)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client).to receive(:put).with(version: :v2, idempotency_key:).and_return(put_proc)
      end

      it 'passes idempotency_key to the PUT method' do
        manager.upload_document(onboarding_id, slot_key, file: file_path, idempotency_key:)

        expect(client).to have_received(:put).with(version: :v2, idempotency_key:)
      end
    end
  end

  describe '#upload_shareholder_document' do
    let(:file_path) { 'spec/support/fixtures/sample_document.pdf' }

    it 'puts a multipart file to the shareholder document path' do
      manager.upload_shareholder_document(onboarding_id, shareholder_id, file: file_path)

      expect(client).to have_received(:put).with(version: :v2, idempotency_key: nil)
      expect(put_proc).to have_received(:call).with(
        "#{base_path}/#{onboarding_id}/shareholders/#{shareholder_id}/document",
        form: { file: file_path }
      )
      expect(Fintoc::V2::Onboarding).to have_received(:new).with(**full_onboarding_data, client:)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client).to receive(:put).with(version: :v2, idempotency_key:).and_return(put_proc)
      end

      it 'passes idempotency_key to the PUT method' do
        manager.upload_shareholder_document(
          onboarding_id, shareholder_id, file: file_path, idempotency_key:
        )

        expect(client).to have_received(:put).with(version: :v2, idempotency_key:)
      end
    end
  end

  describe '#upload_legal_representative_document' do
    let(:slot_key) { 'identification' }
    let(:file_path) { 'spec/support/fixtures/sample_document.pdf' }

    it 'puts a multipart file to the legal representative document slot path' do
      manager.upload_legal_representative_document(
        onboarding_id, legal_representative_id, slot_key, file: file_path
      )

      expect(client).to have_received(:put).with(version: :v2, idempotency_key: nil)
      expect(put_proc).to have_received(:call).with(
        "#{base_path}/#{onboarding_id}/legal_representatives" \
        "/#{legal_representative_id}/documents/#{slot_key}",
        form: { file: file_path }
      )
      expect(Fintoc::V2::Onboarding).to have_received(:new).with(**full_onboarding_data, client:)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client).to receive(:put).with(version: :v2, idempotency_key:).and_return(put_proc)
      end

      it 'passes idempotency_key to the PUT method' do
        manager.upload_legal_representative_document(
          onboarding_id, legal_representative_id, slot_key, file: file_path, idempotency_key:
        )

        expect(client).to have_received(:put).with(version: :v2, idempotency_key:)
      end
    end
  end
end
