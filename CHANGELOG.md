# Changelog

## Unreleased

### 🚀 New Features

- **Onboardings**: Added the full onboarding lifecycle under v2 entities. Onboardings are nested off an `Entity` instance via `entity.onboardings`:
  - `list`, `get`, and `create` (the create body is passed through as-is and validated by the API)
  - `submit` to send an onboarding for review
  - `upload_document` and `upload_shareholder_document` for multipart document uploads
- **Multipart uploads**: Added multipart `form` support and a `put` verb to the HTTP layer to back the onboarding document uploads (uploads are not JWS-signed).
- **Entity attributes**: Added `status` and `country_code` to the v2 `Entity` resource.

## 1.2.0 - 2026-04-08

### 🚀 New Features

- **Account Statements**: Added `account_statements` resource under v2 accounts for retrieving account statements
- **Account Number Deletion**: Added `delete` method for account numbers in the v2 API
- **Movements**: Added `movements` resource under v2 accounts

## 1.1.0 - 2025-09-15

### 🚀 New Features

- **Idempotency Key Support**: Added comprehensive idempotency key support across all V2 API operations to help prevent duplicate operations during network issues or retries
  - **Accounts**: `create` and `update` methods now accept the `idempotency_key` parameter
  - **Account Numbers**: `create` and `update` methods support idempotency keys
  - **Transfers**: `create` and `return` operations support idempotency keys
  - **Account Verifications**: `create` method supports idempotency keys
  - **Simulation**: `receive_transfer` method supports idempotency keys
  - **Resource-level methods**: Instance methods like `account.update`, `transfer.return_transfer`, and `account.simulate_receive_transfer` all support idempotency keys

## 1.0.0 - 2025-09-05

### 🚀 New Features

- **New Client Architecture**: Restructured client to distinguish between API versions
  - Movements API now accessible via `Fintoc::V1::Client`
  - Transfers API accessible via `Fintoc::V2::Client`
  - Unified client interface with `Fintoc::Client` providing access to both versions
  - Backward compatibility maintained for existing method signatures

- **V2 Client - Transfers API Implementation**: Partial implementation of Transfers API endpoints in `Fintoc::V2::Client`
  - **Entities**: List and retrieve business entities
  - **Accounts**: Create, read, update, and list accounts
  - **Account Numbers**: Manage account numbers/CLABEs
  - **Transfers**: Create, retrieve, list, and return transfers
  - **Simulation**: Simulate receiving transfers for testing
  - **Account Verifications**: Verify account numbers
  - **Movements**: TODO! Not yet implemented

### 🧪 Testing & Quality

- **100% Line Coverage**: Achieved full line coverage using SimpleCov gem, increasing the spec coverage and testing all new code.
  - Configured with `minimum_coverage 100` and `minimum_coverage_by_file 100`
  - Uses `simplecov_text_formatter` and `simplecov_linter_formatter` for reporting

- **Robust CI Pipeline**: Enhanced GitHub Actions workflow for comprehensive testing
  - **Linting**: Dedicated RuboCop job for code quality enforcement
  - **Multi-version Testing**: Tests against all currently supported Ruby versions (3.2, 3.3, and 3.4) for version compatibility
  - **Coverage Integration**: Automated coverage reporting in CI pipeline

### Others

- **Money-Rails Integration**: Added `money-rails` gem for proper currency handling
- **Comprehensive README Update**: Extensively updated documentation with usage examples and development instructions
- **Improved Error Handling**: Better error management across API versions
- **JWS Support**: JSON Web Signature support for secure V2 API operations
- **HMac Signature verification**: Added the `Fintoc::WebhookSignature` class for easing webhook signature verification

## 0.1.0 - 2021-01-18

Initial version

- Up to date with the [2020-11-17](https://docs.fintoc.com/docs/api-changelog#2020-11-17) API version
