# Fintoc meets Ruby

You have just found the [Ruby](https://www.ruby-lang.org/)-flavored client of [Fintoc](https://fintoc.com). It mainly consists of a port (more of a carbon copy, really) of [fintoc-python](https://github.com/fintoc-com/fintoc-python).

## Why?

You can think of [Fintoc API](https://fintoc.com/docs) as a piscola.
And the key ingredient to a properly made piscola are the ice cubes.
Sure, you can still have a [piscola without ice cubes](https://curl.haxx.se/).
But hey… that’s not enjoyable -- why would you do that?
Do yourself a favor: go grab some ice cubes by installing this refreshing library.

## Table of contents

- [Fintoc meets Ruby](#fintoc-meets-ruby)
  - [Why?](#why)
  - [Table of contents](#table-of-contents)
  - [How to Install](#how-to-install)
  - [Quickstart](#quickstart)
  - [Client Architecture](#client-architecture)
    - [**API V1 Client**](#api-v1-client)
    - [**API V2 Client**](#api-v2-client)
    - [**Backward compatibility**](#backward-compatibility)
  - [Documentation](#documentation)
  - [Examples](#examples)
    - [Movements API Examples](#movements-api-examples)
      - [Get accounts](#get-accounts)
      - [Get movements](#get-movements)
    - [Transfers API Examples](#transfers-api-examples)
      - [Entities](#entities)
      - [Accounts](#accounts)
      - [Account Numbers](#account-numbers)
      - [Transfers](#transfers)
      - [Simulate](#simulate)
      - [Account Verifications](#account-verifications)
    - [Entity onboardings API Examples](#entity-onboardings-api-examples)
  - [Idempotency Keys](#idempotency-keys)
    - [Idempotency Examples](#idempotency-examples)
      - [Account Methods with Idempotency Key](#account-methods-with-idempotency-key)
      - [Account Number Methods with Idempotency Key](#account-number-methods-with-idempotency-key)
      - [Transfer Methods with Idempotency Key](#transfer-methods-with-idempotency-key)
      - [Simulation with Idempotency Key](#simulation-with-idempotency-key)
      - [Account Verification with Idempotency Key](#account-verification-with-idempotency-key)
    - [About idempotency keys](#about-idempotency-keys)
  - [Development](#development)
    - [Dependencies](#dependencies)
    - [Setup](#setup)
  - [Contributing](#contributing)

## How to Install

Add this line to your application's Gemfile:

```ruby
gem 'fintoc'
```

And then execute:

  $ bundle install

Or install it yourself as:

  $ gem install fintoc

## Quickstart

1. Get your API key and link your bank account using the [Fintoc dashboard](https://app.fintoc.com/login).
2. Open your command-line interface.
3. Write a few lines of Ruby code to see your bank movements.

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')
link = client.v1.links.get('link_token')
account = link.find(type: 'checking_account')

# Get the last 30 movements
movements = account.movements.list

# Or get all the movements since a specific date
movements = account.movements.list(since: '2020-08-15')
```

And that’s it!

## Client Architecture

The Fintoc Ruby client is organized into separate clients that mirror the official API structure:

### **API V1 Client**

The API client currently provides access to part of the Movements API:

```ruby
client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

# Link management
links = client.v1.links.list
link = client.v1.links.get('link_token')
client.v1.links.delete('link_id')

# Account access
account = link.find(id: account_id)
```

### **API V2 Client**

The API V2 client currently provides access to part of the Transfers API:

```ruby
client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

# Entities
entities = client.v2.entities.list
entity = client.v2.entities.get('entity_id')

# Accounts
accounts = client.v2.accounts.list
account = client.v2.accounts.get('account_id')
account = client.v2.accounts.create(entity_id: 'entity_id', description: 'My Account')
client.v2.accounts.update('account_id', description: 'Updated')

# Account Numbers
account_numbers = client.v2.account_numbers.list
account_number = client.v2.account_numbers.get('account_number_id')
account_number = client.v2.account_numbers.create(account_id: 'account_id', description: 'Main')
client.v2.account_numbers.update('account_number_id', description: 'Updated')

# Transfers
transfers = client.v2.transfers.list
transfer = client.v2.transfers.get('transfer_id')
transfer = client.v2.transfers.create(
  amount: 1000,
  currency: 'CLP',
  account_id: 'account_id',
  counterparty: {...}
)
client.v2.transfers.return('transfer_id')

# Simulate
simulated_transfer = client.v2.simulate.receive_transfer(
  account_number_id: 'account_number_id',
  amount: 1000,
  currency: 'CLP'
)

# Account Verifications
account_verifications = client.v2.account_verifications.list
account_verification = client.v2.account_verifications.get('account_verification_id')
account_verification = client.v2.account_verifications.create(account_number: 'account_number')

# Entity onboardings
entity = client.v2.entities.get('entity_id')
onboardings = entity.onboardings.list
onboarding = entity.onboardings.get('onboarding_id')

# TODO: Movements
```

### **Backward compatibility**

The methods of the previous `Fintoc::Client` class implementation are kept for backward compatibility purposes.

```ruby
client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

link = client.get_link('link_token')
links = client.get_links
client.delete_link(link.id)
account = client.get_account('link_token', 'account_id')
```

## Documentation

This client does not support all Fintoc API endpoints yet. For complete information about the API, head to the [docs](https://docs.fintoc.com/reference).

## Examples

### Movements API Examples

#### Get accounts

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')
link = client.v1.links.get('link_token')
puts link.accounts

# Or... you can pretty print all the accounts in a Link

link = client.v1.links.get('link_token')
link.show_accounts

```

If you want to find a specific account in a link, you can use **find**. You can search by any account field:

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')
link = client.v1.links.get('link_token')
account = link.find(type: 'checking_account')

# Or by number
account = link.find(number: '1111111')

# Or by account id
account = link.find(id: 'sdfsdf234')
```

You can also search for multiple accounts matching a specific criteria with **find_all**:

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')
link = client.v1.links.get('link_token')
accounts = link.find_all(currency: 'CLP')
```

To update the account balance you can use **update_balance**:

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')
link = client.v1.links.get('link_token')
account = link.find(number: '1111111')
account.update_balance
```

#### Get movements

```ruby
require 'fintoc'
require 'time'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')
link = client.v1.links.get('link_token')
account = link.find(type: 'checking_account')

# You can get the account movements since a specific DateTime
yesterday = DateTime.now - 1
account.movements.list(since: yesterday)

# Or you can use an ISO 8601 formatted string representation of the Date
account.movements.list(since: '2020-01-01')

# You can also set how many movements you want per_page
account.movements.list(since: '2020-01-01', per_page: 100)
```

Calling **movements.list** without arguments gets the last 30 movements of the account

### Transfers API Examples

#### Entities

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

# Get all entities
entities = client.v2.entities.list

# Get a specific entity
entity = client.v2.entities.get('entity_id')
```

You can also list entities with pagination:

```ruby
# Get entities with pagination
entities = client.v2.entities.list(limit: 10, starting_after: 'entity_id')
```

#### Accounts

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

# Create an account
account = client.v2.accounts.create(
  entity_id: 'entity_id',
  description: 'My Business Account'
)

# Get a specific account
account = client.v2.accounts.get('account_id')

# List all accounts
accounts = client.v2.accounts.list

# Update an account
updated_account = client.v2.accounts.update('account_id', description: 'Updated Description')
```

#### Account Numbers

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

# Create an account number
account_number = client.v2.account_numbers.create(
  account_id: 'account_id',
  description: 'Main account number'
)

# Get a specific account number
account_number = client.v2.account_numbers.get('account_number_id')

# List all account numbers
account_numbers = client.v2.account_numbers.list

# Update an account number
updated_account_number = client.v2.account_numbers.update(
  'account_number_id',
  description: 'Updated account number'
)
```

#### Transfers

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

# Create a transfer
transfer = client.v2.transfers.create(
  amount: 10000,
  currency: 'CLP',
  account_id: 'account_id',
  counterparty: {
    name: 'John Doe',
    rut: '12345678-9',
    email: 'john@example.com',
    bank: 'banco_de_chile',
    account_type: 'checking_account',
    account_number: '1234567890'
  }
)

# Get a specific transfer
transfer = client.v2.transfers.get('transfer_id')

# List all transfers
transfers = client.v2.transfers.list

# Return a transfer
returned_transfer = client.v2.transfers.return('transfer_id')
```

#### Simulate

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

# Simulate receiving a transfer
simulated_transfer = client.v2.simulate.receive_transfer(
  account_number_id: 'account_number_id',
  amount: 5000,
  currency: 'CLP'
)
```

#### Account Verifications

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

# Create an account verification
account_verification = client.v2.account_verifications.create(account_number: 'account_number')

# Get a specific account verification
account_verification = client.v2.account_verifications.get('account_verification_id')

# List all account verifications
account_verifications = client.v2.account_verifications.list
```

### Entity onboardings API Examples

An entity onboarding represents the onboarding process for an entity. You access it from
an `Entity` instance (`entity.onboardings`); the full lifecycle is available: list,
retrieve, create, submit, and upload documents to a slot.

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')
entity = client.v2.entities.get('entity_id')

# List the onboardings of an entity (cursor-paginated, light shape)
onboardings = entity.onboardings.list

# Retrieve a single onboarding (full shape, includes legal representatives,
# shareholders and documents)
onboarding = entity.onboardings.get('onboarding_id')
puts onboarding                     # 📋 Onboarding onbprc_0ujs... (in_progress)
onboarding.type                     # => 'account_holder'
onboarding.legal_representatives    # => array of legal representative hashes
onboarding.shareholders             # => array of shareholder hashes
onboarding.documents                # => array of document hashes

# Create an onboarding. `type` selects the onboarding to run (`account_holder` or
# `settlement_recipient`) and `data` holds the nested structures, which are passed
# through as-is and validated by the API.
onboarding = entity.onboardings.create(
  type: 'account_holder',
  data: {
    company_information: {
      incorporation_date: '2020-01-15',
      business_activity: 'Servicios financieros',
      fiscal_address: 'Av. Reforma 123, CDMX',
      business_address: 'Av. Insurgentes 456, CDMX',
      settlement_account: '646180357600000013',
      phone: '+521111111111'
    },
    legal_representatives: [
      {
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'jane@acme.com',
        nationality: 'mx',
        identification_number: 'AAAA010101HDFAAA01',
        position: 'Director General'
      }
    ],
    transactional_profile: {
      resource_origins: %w[trusts investments],
      monthly_amount_range: '1_500000',
      monthly_operations_range: '1_15000'
    },
    shareholders: [
      {
        type: 'natural_person',
        name: 'Jane',
        last_name: 'Doe',
        holder_id: 'AAAA010101AAA',
        nationality: 'mx',
        percentage: 100
      }
    ]
  }
)

# Upload a document for a given slot (multipart). `file:` accepts a path or an IO.
entity.onboardings.upload_document('onboarding_id', 'slot_key', file: 'path/to/file.pdf')

# Upload a document for a specific shareholder (multipart).
entity.onboardings.upload_shareholder_document(
  'onboarding_id', 'shareholder_id', file: 'path/to/file.pdf'
)

# Upload a document for a specific legal representative (multipart).
# Slots: `identification` and `power_of_attorney`.
entity.onboardings.upload_legal_representative_document(
  'onboarding_id', 'legal_representative_id', 'identification', file: 'path/to/file.pdf'
)

# Submit the onboarding for review.
onboarding = entity.onboardings.submit('onboarding_id')
```

## Idempotency Keys

The Fintoc API supports [idempotency](https://docs.fintoc.com/reference/idempotent-requests) for safely retrying requests without accidentally performing the same operation twice. This is particularly useful when creating transfers, account numbers, accounts, or other resources where you want to avoid duplicates due to network issues.

To use idempotency keys, provide an `idempotency_key` parameter when making POST/PATCH requests:

### Idempotency Examples

#### Account Methods with Idempotency Key

Create and update methods support the use of idempotency keys to prevent duplication:

```ruby
require 'fintoc'
require 'securerandom'

client = Fintoc::Client.new('api_key', jws_private_key: 'jws_private_key')

idempotency_key = SecureRandom.uuid
account = client.v2.accounts.create(
  entity_id: 'entity_id', description: 'My Business Account', idempotency_key:
)

idempotency_key = SecureRandom.uuid
updated_account = client.v2.accounts.update(
  'account_id', description: 'Updated Description', idempotency_key:
)
```

Simulation of transfers can also be done with idempotency key:

```ruby
idempotency_key = SecureRandom.uuid
account.simulate_receive_transfer(amount: 1000, idempotency_key:)
```

#### Account Number Methods with Idempotency Key

Create and update methods support the use of idempotency keys as well:

```ruby
idempotency_key = SecureRandom.uuid
account_number = client.v2.account_numbers.create(
  account_id: 'account_id', description: 'Main account number', idempotency_key:
)

idempotency_key = SecureRandom.uuid
updated_account_number = client.v2.account_numbers.update(
  'account_number_id', description: 'Updated description', idempotency_key:
)
```

Simulation of transfers can also be done with idempotency key:

```ruby
account_number.simulate_receive_transfer(amount: 1000, currency: 'MXN', idempotency_key:)
```

#### Transfer Methods with Idempotency Key

Creating and returning transfers support the use of idempotency keys:

```ruby
idempotency_key = SecureRandom.uuid
transfer = client.v2.transfers.create(
  amount: 10000, currency: 'CLP', account_id: 'account_id', counterparty: { ... }, idempotency_key:
)

idempotency_key = SecureRandom.uuid
returned_transfer = client.v2.transfers.return('transfer_id', idempotency_key:)
```

Returning a transfer as an instance method also supports the use of idempotency key:

```ruby
idempotency_key = SecureRandom.uuid
transfer.return_transfer(idempotency_key:)
```

#### Simulation with Idempotency Key

For simulating transfers, the use of idempotency keys is also supported:

```ruby
idempotency_key = SecureRandom.uuid
simulated_transfer = client.v2.simulate.receive_transfer(
  account_number_id: 'account_number_id', amount: 5000, currency: 'CLP', idempotency_key:
)
```

#### Account Verification with Idempotency Key

```ruby
idempotency_key = SecureRandom.uuid
account_verification = client.v2.account_verifications.create(
  account_number: 'account_number', idempotency_key:
)
```

### About idempotency keys

- Idempotency keys can be up to 255 characters long
- Use consistent unique identifiers for the same logical operation (e.g. order IDs, transaction references). If you set them randomly, we suggest using V4 UUIDs, or another random string with enough entropy to avoid collisions.
- The same idempotency key will return the same result, including errors
- Keys are automatically removed after 24 hours
- Only POST and PATCH requests currently support idempotency keys
- If parameters differ with the same key, an error will be raised

For more information, see the [Fintoc API documentation on idempotent requests](https://docs.fintoc.com/reference/idempotent-requests).

## Development

### Dependencies

This gem supports **Ruby 2.3+** but development requires modern tooling:

- **Ruby:** 2.3+ (3.2+ recommended for development)
- **Bundler:** 2.7+ (for development)
- **Git:** For version control

### Setup

```bash
# Clone the repository
git clone https://github.com/fintoc-com/fintoc-ruby.git
cd fintoc-ruby

# Install dependencies (requires Bundler 2.7+)
bundle install

# Run tests
bundle exec rspec

# Run linting
bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/fintoc-com/fintoc-ruby](https://github.com/fintoc-com/fintoc-ruby).
