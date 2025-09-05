require 'fintoc/jws'
require 'openssl'
require 'json'
require 'base64'

RSpec.describe Fintoc::JWS do
  let(:private_key) do
    OpenSSL::PKey::RSA.new(2048)
  end

  let(:jws) { described_class.new(private_key) }

  describe '#initialize' do
    it 'accepts an OpenSSL::PKey::RSA object' do
      expect { described_class.new(private_key) }.not_to raise_error
    end

    it 'raises an error for invalid input' do
      expect { described_class.new('invalid_string') }
        .to raise_error(ArgumentError, 'private_key must be an OpenSSL::PKey::RSA instance')
    end

    it 'raises an error for numeric input' do
      expect { described_class.new(123) }
        .to raise_error(ArgumentError, 'private_key must be an OpenSSL::PKey::RSA instance')
    end
  end

  describe '#generate_signature' do
    let(:payload) { { amount: 1000, currency: 'MXN' } }

    it 'generates a valid JWS signature' do
      signature = jws.generate_signature(payload)

      expect(signature).to be_a(String)
      expect(signature.split('.').length).to eq(2)
    end

    it 'includes required headers' do
      signature = jws.generate_signature(payload)
      parsed = jws.parse_signature(signature)

      expect(parsed[:protected_headers]).to include(
        alg: 'RS256',
        nonce: be_a(String),
        ts: be_a(Integer),
        crit: %w[ts nonce]
      )
    end

    it 'accepts string payloads' do
      string_payload = '{"amount":1000,"currency":"MXN"}'
      signature = jws.generate_signature(string_payload)

      expect(signature).to be_a(String)
      expect(signature.split('.').length).to eq(2)
    end

    it 'generates different signatures for the same payload' do
      signature1 = jws.generate_signature(payload)
      signature2 = jws.generate_signature(payload)

      expect(signature1).not_to eq(signature2)
    end

    it 'generates verifiable signatures' do
      signature = jws.generate_signature(payload)

      expect(jws.verify_signature(signature, payload)).to be true
    end
  end

  describe '#parse_signature' do
    let(:payload) { { amount: 1000, currency: 'MXN' } }
    let(:signature) { jws.generate_signature(payload) }

    it 'parses signature components correctly' do
      parsed = jws.parse_signature(signature)

      expect(parsed).to include(
        protected_headers: be_a(Hash),
        signature_bytes: be_a(String),
        protected_b64: be_a(String),
        signature_b64: be_a(String)
      )
    end

    it 'includes correct header values' do
      parsed = jws.parse_signature(signature)

      expect(parsed[:protected_headers]).to include(
        alg: 'RS256',
        crit: %w[ts nonce]
      )
    end
  end

  describe '#verify_signature' do
    let(:payload) { { amount: 1000, currency: 'MXN' } }

    it 'verifies valid signatures' do
      signature = jws.generate_signature(payload)
      expect(jws.verify_signature(signature, payload)).to be true
    end

    it 'rejects signatures with wrong payload' do
      signature = jws.generate_signature(payload)
      wrong_payload = { amount: 2000, currency: 'CLP' }

      expect(jws.verify_signature(signature, wrong_payload)).to be false
    end

    it 'works with string payloads' do
      string_payload = '{"amount":1000,"currency":"MXN"}'
      signature = jws.generate_signature(string_payload)

      expect(jws.verify_signature(signature, string_payload)).to be true
    end
  end
end
