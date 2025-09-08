# Changelog

## 1.0.0 - 2025-09-05

### 🚀 New Features

- **New Client Architecture**: Restructured client to distinguish between API versions
  - Movements API now accessible via `Fintoc::V1::Client`
  - Transfers API accessible via `Fintoc::V2::Client`
  - Unified client interface with `Fintoc::Client` providing access to both versions
  - Backward compatibility maintained for existing method signatures

- **V2 Client - Transfers API Implementation**: Partial implementation of Transfers API endpoints in `Fintoc::V2::Client`
  - **Entities**: List and retrieve business entities
  - **Transfer Accounts**: Create, read, update, and list transfer accounts
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

* Up to date with the [2020-11-17](https://docs.fintoc.com/docs/api-changelog#2020-11-17) API version
