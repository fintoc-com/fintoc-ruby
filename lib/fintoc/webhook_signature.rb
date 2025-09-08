# frozen_string_literal: true

require 'openssl'
require 'time'
require 'fintoc/errors'

module Fintoc
  class WebhookSignature
    EXPECTED_SCHEME = 'v1'
    DEFAULT_TOLERANCE = 300 # 5 minutes

    class << self
      def verify_header(payload, header, secret, tolerance = DEFAULT_TOLERANCE) # rubocop:disable Naming/PredicateMethod
        timestamp, signatures = parse_header(header)

        verify_timestamp(timestamp, tolerance) if tolerance

        expected_signature = compute_signature(payload, timestamp, secret)
        signature = signatures[EXPECTED_SCHEME]

        if signature.nil? || signature.empty? # rubocop:disable Rails/Blank
          raise Fintoc::Errors::WebhookSignatureError.new("No #{EXPECTED_SCHEME} signature found")
        end

        unless same_signatures?(signature, expected_signature)
          raise Fintoc::Errors::WebhookSignatureError.new('Signature mismatch')
        end

        true
      end

      def compute_signature(payload, timestamp, secret)
        signed_payload = "#{timestamp}.#{payload}"
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, signed_payload)
      end

      private

      def parse_header(header)
        elements = header.split(',').map(&:strip)
        pairs = elements.map { |element| element.split('=', 2).map(&:strip) }
        pairs = pairs.to_h

        if pairs['t'].nil? || pairs['t'].empty? # rubocop:disable Rails/Blank
          raise Fintoc::Errors::WebhookSignatureError.new('Missing timestamp in header')
        end

        timestamp = pairs['t'].to_i
        signatures = pairs.except('t')

        [timestamp, signatures]
      rescue StandardError => e
        raise Fintoc::Errors::WebhookSignatureError.new(
          'Unable to extract timestamp and signatures from header'
        ), cause: e
      end

      def verify_timestamp(timestamp, tolerance)
        now = Time.now.to_i

        if timestamp < (now - tolerance)
          raise Fintoc::Errors::WebhookSignatureError.new(
            "Timestamp outside the tolerance zone (#{timestamp})"
          )
        end
      end

      def same_signatures?(signature, expected_signature)
        OpenSSL.secure_compare(expected_signature, signature)
      end
    end
  end
end
