require 'fintoc/constants'

module Fintoc
  module Errors
    class FintocError < StandardError
      def initialize(message, doc_url = Fintoc::Constants::GENERAL_DOC_URL)
        super(message)

        @message = message
        @doc_url = doc_url
      end

      def message
        "\n#{@message}\n Please check the docs at: #{@doc_url}"
      end
    end

    # 400 Bad Request Errors
    class InvalidRequestError < FintocError; end
    class InvalidCurrencyError < FintocError; end
    class InvalidAmountError < FintocError; end
    class InvalidAccountTypeError < FintocError; end
    class InvalidAccountNumberError < FintocError; end
    class InvalidAccountStatusError < FintocError; end
    class InvalidAccountBalanceError < FintocError; end
    class InvalidInstitutionIdError < FintocError; end
    class CurrencyMismatchError < FintocError; end
    class InvalidCommentSizeError < FintocError; end
    class InvalidReferenceIdSizeError < FintocError; end
    class MissingParameterError < FintocError; end
    class InvalidPositiveIntegerError < FintocError; end
    class EmptyStringError < FintocError; end
    class InvalidStringSizeError < FintocError; end
    class InvalidHashError < FintocError; end
    class InvalidBooleanError < FintocError; end
    class InvalidArrayError < FintocError; end
    class InvalidIntegerError < FintocError; end
    class InvalidJsonError < FintocError; end
    class InvalidParamsError < FintocError; end
    class MissingCursorError < FintocError; end
    class InvalidEnumError < FintocError; end
    class InvalidStringError < FintocError; end
    class InvalidUsernameError < FintocError; end
    class InvalidLinkTokenError < FintocError; end
    class InvalidDateError < FintocError; end
    class InvalidHolderIdError < FintocError; end
    class InvalidCardNumberError < FintocError; end
    class InvalidProductError < FintocError; end
    class InvalidWebhookSubscriptionError < FintocError; end
    class InvalidIssueTypeError < FintocError; end
    class InvalidRefreshTypeError < FintocError; end
    class InvalidBusinessProfileTaxIdError < FintocError; end
    class InvalidSessionHolderIdError < FintocError; end
    class InvalidPaymentRecipientAccountError < FintocError; end
    class InvalidPayoutRecipientAccountError < FintocError; end
    class InvalidWidgetTokenError < FintocError; end
    class InvalidPaymentReferenceNumberError < FintocError; end
    class InvalidOnDemandLinkError < FintocError; end
    class InvalidHolderTypeError < FintocError; end
    class InvalidVoucherDownloadError < FintocError; end
    class InvalidModeError < FintocError; end
    class InvalidRsaKeyError < FintocError; end
    class ExpectedPublicRsaKeyError < FintocError; end
    class InvalidCidrBlockError < FintocError; end
    class InvalidExpiresAtError < FintocError; end
    class InvalidInstallmentsCurrencyError < FintocError; end
    class InvalidClabeError < FintocError; end
    class MismatchTransferAccountCurrencyError < FintocError; end
    class InvalidTransfersError < FintocError; end
    class InvalidTransfersSizeError < FintocError; end
    class InvalidDescriptionSizeError < FintocError; end
    class InvalidBillingCycleAnchorError < FintocError; end
    class InvalidCountryCodeError < FintocError; end
    class InvalidEmailError < FintocError; end
    class InvalidInvoiceStatusError < FintocError; end
    class InvalidMetadataError < FintocError; end
    class InvalidPeriodError < FintocError; end
    class InvalidReferenceIdFormatError < FintocError; end
    class InvalidRefundToGetVoucherError < FintocError; end
    class InvalidRutError < FintocError; end
    class InvalidShareholderStructureError < FintocError; end
    class InvalidWebhookEventTypeError < FintocError; end
    class MinimumAmountError < FintocError; end
    class MutuallyExclusiveParamsError < FintocError; end
    class NotSupportedRefundableResourceTypeError < FintocError; end
    class SplitSumMismatchError < FintocError; end

    # 401 Unauthorized Errors
    class AuthenticationError < FintocError; end
    class InvalidApiKeyError < FintocError; end
    class ExpiredApiKeyError < FintocError; end
    class InvalidApiKeyModeError < FintocError; end
    class ExpiredExchangeTokenError < FintocError; end
    class InvalidExchangeTokenError < FintocError; end
    class MissingActiveJwsPublicKeyError < FintocError; end
    class InvalidJwsSignatureAlgorithmError < FintocError; end
    class InvalidJwsSignatureHeaderError < FintocError; end
    class InvalidJwsSignatureNonceError < FintocError; end
    class InvalidJwsSignatureTimestampError < FintocError; end
    class InvalidJwsSignatureTimestampFormatError < FintocError; end
    class InvalidJwsSignatureTimestampValueError < FintocError; end
    class MissingJwsSignatureHeaderError < FintocError; end
    class JwsNonceAlreadyUsedError < FintocError; end
    class InvalidJwsTsError < FintocError; end

    # 402 Payment Required Errors
    class PaymentRequiredError < FintocError; end

    # 403 Forbidden Errors
    class InvalidAccountError < FintocError; end
    class InvalidRecipientAccountError < FintocError; end
    class AccountNotActiveError < FintocError; end
    class EntityNotOperationalError < FintocError; end
    class ForbiddenEntityError < FintocError; end
    class ForbiddenAccountError < FintocError; end
    class ForbiddenAccountNumberError < FintocError; end
    class ForbiddenAccountVerificationError < FintocError; end
    class InvalidApiVersionError < FintocError; end
    class ProductAccessRequiredError < FintocError; end
    class ForbiddenRequestError < FintocError; end
    class MissingAllowedCidrBlocksError < FintocError; end
    class AllowedCidrBlocksDoesNotContainIpError < FintocError; end
    class RecipientBlockedAccountError < FintocError; end
    class InvalidAccountVerificationError < FintocError; end
    class PaymentMethodNotRefundableError < FintocError; end

    # 404 Not Found Errors
    class MissingResourceError < FintocError; end
    class InvalidUrlError < FintocError; end
    class OrganizationWithoutEntitiesError < FintocError; end
    class ResourceNotFoundError < FintocError; end

    # 405 Method Not Allowed Errors
    class OperationNotAllowedError < FintocError; end

    # 406 Not Acceptable Errors
    class InstitutionCredentialsInvalidError < FintocError; end
    class LockedCredentialsError < FintocError; end
    class UnavailableInstitutionError < FintocError; end

    # 409 Conflict Errors
    class InsufficientBalanceError < FintocError; end
    class InvalidDuplicatedTransferError < FintocError; end
    class InvalidTransferStatusError < FintocError; end
    class InvalidTransferDirectionError < FintocError; end
    class AccountNumberLimitReachedError < FintocError; end
    class AccountCannotBeBlockedError < FintocError; end
    class InvalidSenderAccountsError < FintocError; end
    class AccountNumberCouldNotBeAssignedError < FintocError; end
    class AccountNumberTakenError < FintocError; end
    class BlockedAccountNumberError < FintocError; end
    class ConflictedRequestError < FintocError; end
    class DisputeDeadlineExceededError < FintocError; end
    class DisputeNotOpenForDocumentsError < FintocError; end
    class DuplicateRecipientError < FintocError; end
    class EntityHolderIdAlreadyExistsForOrganizationError < FintocError; end
    class InvalidEmptySubscriptionError < FintocError; end
    class InvoiceNotEditableError < FintocError; end
    class InvoiceNotFinalizableError < FintocError; end
    class InvoiceNotMarkableUncollectibleError < FintocError; end
    class NoDocumentsToSubmitError < FintocError; end
    class PaymentMethodNonCancelableError < FintocError; end
    class PaymentNonCancelableError < FintocError; end
    class PaymentNonExpirableError < FintocError; end
    class SubscriptionNotEditableError < FintocError; end

    # 422 Unprocessable Entity Errors
    class InvalidOtpCodeError < FintocError; end
    class OtpNotFoundError < FintocError; end
    class OtpBlockedError < FintocError; end
    class OtpVerificationFailedError < FintocError; end
    class OtpAlreadyExistsError < FintocError; end
    class SubscriptionInProgressError < FintocError; end
    class OnDemandPolicyRequiredError < FintocError; end
    class OnDemandRefreshUnavailableError < FintocError; end
    class NotSupportedCountryError < FintocError; end
    class NotSupportedCurrencyError < FintocError; end
    class NotSupportedModeError < FintocError; end
    class NotSupportedProductError < FintocError; end
    class RefreshIntentInProgressError < FintocError; end
    class RejectedRefreshIntentError < FintocError; end
    class SenderBlockedAccountError < FintocError; end
    class AmountOutOfRangeError < FintocError; end
    class CountryNotSupportedError < FintocError; end
    class DirectDebitSuspendedError < FintocError; end
    class FileTooLargeError < FintocError; end
    class FileTooSmallError < FintocError; end
    class InvalidAccountForDirectDebitError < FintocError; end
    class InvalidPaymentMethodStateError < FintocError; end
    class InvoiceHasPendingPaymentError < FintocError; end
    class InvoiceNotPayableError < FintocError; end
    class InvoiceNotVoidableError < FintocError; end
    class LegalRepresentativeRequiredError < FintocError; end
    class MandateLimitExceededError < FintocError; end
    class MerchantChargeLimitExceededError < FintocError; end
    class MerchantVolumeLimitExceededError < FintocError; end
    class NotOneDayCompanyError < FintocError; end
    class OnboardingImmutableError < FintocError; end
    class OnboardingNotAvailableError < FintocError; end
    class OrganizationWithoutOperationalRootEntityError < FintocError; end
    class PaymentCancellationNotSupportedError < FintocError; end
    class PaymentMethodInactiveError < FintocError; end
    class PaymentMethodTypeNotAvailableError < FintocError; end
    class PaymentMethodTypeNotSupportedError < FintocError; end
    class PaymentMethodUnavailableError < FintocError; end
    class RecipientAccountNotAllowedError < FintocError; end
    class RequiredDocumentMissingError < FintocError; end
    class RootEntityNotSupportedViaApiError < FintocError; end
    class ShareholderDocumentNotRequiredError < FintocError; end
    class SingleFileDocumentSlotError < FintocError; end
    class SubscriptionCanceledError < FintocError; end
    class UnknownDocumentSlotError < FintocError; end
    class UnsupportedContentTypeError < FintocError; end
    class UnsupportedInstitutionError < FintocError; end
    class UnsupportedPaymentTypeError < FintocError; end

    # 429 Too Many Requests Errors
    class RateLimitExceededError < FintocError; end

    # 500 Internal Server Errors
    class InternalServerError < FintocError; end
    class UnrecognizedRequestError < FintocError; end
    class CoreResponseError < FintocError; end

    # 501 Not Implemented Errors
    class OperationNotImplementedError < FintocError; end

    # Webhook Errors
    class WebhookSignatureError < FintocError; end

    # Legacy Errors (keeping existing ones for backward compatibility and just in case)
    class LinkError < FintocError; end
    class InstitutionError < FintocError; end
    class ApiError < FintocError; end
    class InvalidCredentialsError < FintocError; end
  end
end
