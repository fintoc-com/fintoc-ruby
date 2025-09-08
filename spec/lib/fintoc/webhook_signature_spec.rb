require 'fintoc/webhook_signature'

RSpec.describe Fintoc::WebhookSignature do
  let(:secret) { 'test_secret_key' }
  let(:payload) { '{"test": "payload"}' }
  let(:frozen_time) { Time.parse('2025-09-05 10:10:10 UTC') }
  let(:timestamp) { frozen_time.to_i }
  let(:signature) { OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, "#{timestamp}.#{payload}") }
  let(:valid_header) { "t=#{timestamp},v1=#{signature}" }

  before do
    allow(Time).to receive_messages(current: frozen_time, now: frozen_time)
  end

  describe '.verify_header' do
    context 'when signature is valid' do
      it 'returns true' do
        expect(described_class.verify_header(payload, valid_header, secret)).to be true
      end

      it 'returns true with custom tolerance' do
        expect(described_class.verify_header(payload, valid_header, secret, 600)).to be true
      end

      it 'returns true when tolerance is nil (no timestamp verification)' do
        old_timestamp = timestamp - 1000
        old_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret,
                                                "#{old_timestamp}.#{payload}")
        old_header = "t=#{old_timestamp},v1=#{old_signature}"

        expect(described_class.verify_header(payload, old_header, secret, nil)).to be true
      end
    end

    context 'when header does not have a timestamp' do
      let(:invalid_header) { "v1=#{signature}" }

      it 'raises WebhookSignatureError' do
        expect do
          described_class.verify_header(payload, invalid_header, secret)
        end.to raise_error(
          Fintoc::Errors::WebhookSignatureError,
          "\nUnable to extract timestamp and signatures from header\n " \
          'Please check the docs at: https://docs.fintoc.com/reference/errors'
        )
      end
    end

    context 'when timestamp is too old' do
      let(:old_timestamp) { timestamp - 400 }
      let(:old_signature) do
        OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new('sha256'),
          secret,
          "#{old_timestamp}.#{payload}"
        )
      end
      let(:old_header) { "t=#{old_timestamp},v1=#{old_signature}" }

      it 'raises WebhookSignatureError with default tolerance' do
        expect do
          described_class.verify_header(payload, old_header, secret)
        end.to raise_error(
          Fintoc::Errors::WebhookSignatureError,
          "\nTimestamp outside the tolerance zone (#{old_timestamp})\n " \
          'Please check the docs at: https://docs.fintoc.com/reference/errors'
        )
      end

      it 'raises WebhookSignatureError with custom tolerance' do
        expect do
          described_class.verify_header(payload, old_header, secret, 100)
        end.to raise_error(
          Fintoc::Errors::WebhookSignatureError,
          "\nTimestamp outside the tolerance zone (#{old_timestamp})\n " \
          'Please check the docs at: https://docs.fintoc.com/reference/errors'
        )
      end
    end

    context 'when header does not contain signature scheme' do
      let(:header_without_scheme) { "t=#{timestamp}" }

      it 'raises WebhookSignatureError' do
        expect do
          described_class.verify_header(payload, header_without_scheme, secret)
        end.to raise_error(
          Fintoc::Errors::WebhookSignatureError,
          "\nNo v1 signature found\n " \
          'Please check the docs at: https://docs.fintoc.com/reference/errors'
        )
      end
    end

    context 'when signature and expected signature do not match' do
      let(:wrong_signature) { 'wrong_signature_value' }
      let(:invalid_header) { "t=#{timestamp},v1=#{wrong_signature}" }

      it 'raises WebhookSignatureError' do
        expect do
          described_class.verify_header(payload, invalid_header, secret)
        end.to raise_error(
          Fintoc::Errors::WebhookSignatureError,
          "\nSignature mismatch\n " \
          'Please check the docs at: https://docs.fintoc.com/reference/errors'
        )
      end
    end

    context 'with different signature schemes' do
      it 'ignores non-v1 signatures and uses v1' do
        header_with_multiple = "t=#{timestamp},v0=wrong_signature,v1=#{signature},v2=another_wrong"

        expect(described_class.verify_header(payload, header_with_multiple, secret)).to be true
      end
    end

    context 'with malformed headers' do
      it 'raises WebhookSignatureError' do
        header_empty_timestamp = "t=,v1=#{signature}"

        expect do
          described_class.verify_header(payload, header_empty_timestamp, secret)
        end.to raise_error(
          Fintoc::Errors::WebhookSignatureError,
          "\nUnable to extract timestamp and signatures from header\n " \
          'Please check the docs at: https://docs.fintoc.com/reference/errors'
        )
      end
    end
  end
end
