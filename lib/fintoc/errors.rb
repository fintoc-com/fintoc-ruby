require 'fintoc/constants'

module Fintoc
  module Errors
    class FintocError < StandardError
      def initialize(message, doc_url = Fintoc::Constants::GENERAL_DOC_URL)
        @message = message
        @doc_url = doc_url
      end

      def message
        "\n#{@message}\n Please check the docs at: #{@doc_url}"
      end

      def to_s
        message
      end
    end
    class InvalidRequestError < FintocError; end
    class LinkError < FintocError; end
    class AuthenticationError < FintocError; end
    class InstitutionError < FintocError; end
    class ApiError < FintocError; end
    class MissingResourceError < FintocError; end
    class InvalidLinkTokenError < FintocError; end
    class InvalidUsernameError < FintocError; end
    class InvalidHolderTypeError < FintocError; end
    class MissingParameterError < FintocError; end
    class EmptyStringError < FintocError; end
    class UnrecognizedRequestError < FintocError; end
    class InvalidDateError < FintocError; end
    class InvalidCredentialsError < FintocError; end
    class LockedCredentialsError < FintocError; end
    class InvalidApiKeyError < FintocError; end
    class UnavailableInstitutionError < FintocError; end
    class InternalServerError < FintocError; end
  end
end
