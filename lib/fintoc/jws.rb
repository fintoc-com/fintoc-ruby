require 'openssl'
require 'json'
require 'base64'
require 'securerandom'

module Fintoc
  class JWS
    def initialize(private_key)
      unless private_key.is_a?(OpenSSL::PKey::RSA)
        raise ArgumentError, 'private_key must be an OpenSSL::PKey::RSA instance'
      end

      @private_key = private_key
    end

    def generate_signature(raw_body)
      body_string = raw_body.is_a?(Hash) ? raw_body.to_json : raw_body.to_s

      headers = {
        alg: 'RS256',
        nonce: SecureRandom.hex(16),
        ts: Time.now.to_i,
        crit: %w[ts nonce]
      }

      protected_base64 = base64url_encode(headers.to_json)
      payload_base64 = base64url_encode(body_string)
      signing_input = "#{protected_base64}.#{payload_base64}"

      signature = @private_key.sign(OpenSSL::Digest.new('SHA256'), signing_input)
      signature_base64 = base64url_encode(signature)

      "#{protected_base64}.#{signature_base64}"
    end

    def parse_signature(signature)
      protected_b64, signature_b64 = signature.split('.')

      {
        protected_headers: decode_protected_headers(protected_b64),
        signature_bytes: decode_signature(signature_b64),
        protected_b64: protected_b64,
        signature_b64: signature_b64
      }
    end

    def verify_signature(signature, payload)
      parsed = parse_signature(signature)

      # Reconstruct the signing input
      payload_json = payload.is_a?(Hash) ? payload.to_json : payload.to_s
      payload_b64 = base64url_encode(payload_json)
      signing_input = "#{parsed[:protected_b64]}.#{payload_b64}"

      # Verify with public key
      public_key = @private_key.public_key
      public_key.verify(OpenSSL::Digest.new('SHA256'), parsed[:signature_bytes], signing_input)
    end

    private

    def decode_protected_headers(protected_b64)
      padded = add_padding(protected_b64)

      protected_json = Base64.urlsafe_decode64(padded)
      JSON.parse(protected_json, symbolize_names: true)
    end

    def decode_signature(signature_b64)
      padded = add_padding(signature_b64)

      Base64.urlsafe_decode64(padded)
    end

    def add_padding(b64)
      (b64.length % 4).zero? ? b64 : (b64 + ('=' * (4 - (b64.length % 4))))
    end

    def base64url_encode(data)
      Base64.urlsafe_encode64(data).tr('=', '')
    end
  end
end
