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
      - [Transfer Accounts](#transfer-accounts)
      - [Account Numbers](#account-numbers)
      - [Transfers](#transfers)
      - [Simulate](#simulate)
      - [Account Verifications](#account-verifications)
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

client = Fintoc::Client.new('sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx')
link = client_v1.links.get('6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W')
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
client = Fintoc::V1::Client.new('api_key')

# Link management
links = client_v1.links.list
link = client_v1.links.get('link_token')
client_v1.links.delete('link_id')

# Account access
account = link.find(id: account_id)
```

### **API V2 Client**

The API V2 client currently provides access to part of the Transfers API:

```ruby
client = Fintoc::V1::Client.new('api_key')

# Entities
entities = client_v2.entities.list
entity = client_v2.entities.get('entity_id')

# Transfer Accounts
accounts = client_v2.accounts.list
account = client_v2.accounts.get('account_id')
account = client_v2.accounts.create(entity_id: 'entity_id', description: 'My Account')
client_v2.accounts.update('account_id', description: 'Updated')

# Account Numbers
account_numbers = client_v2.account_numbers.list
account_number = client_v2.account_numbers.get('account_number_id')
account_number = client_v2.account_numbers.create(account_id: 'account_id', description: 'Main')
client_v2.account_numbers.update('account_number_id', description: 'Updated')

# Transfers
transfers = client_v2.transfers.list
transfer = client_v2.transfers.get('transfer_id')
transfer = client_v2.transfers.create(
  amount: 1000,
  currency: 'CLP',
  account_id: 'account_id',
  counterparty: {...}
)
client_v2.transfers.return('transfer_id')

# Simulate
simulated_transfer = client_v2.simulate.receive_transfer(
  account_number_id: 'account_number_id',
  amount: 1000,
  currency: 'CLP'
)

# Account Verifications
account_verifications = client_v2.account_verifications.list
account_verification = client_v2.account_verifications.get('account_verification_id')
account_verification = client_v2.account_verifications.create(account_number: 'account_number')

# TODO: Movements
```

### **Backward compatibility**

The methods of the previous `Fintoc::Client` class implementation are kept for backward compatibility purposes.

```ruby
client = Fintoc::V1::Client.new('api_key')

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

client = Fintoc::V1::Client.new('api_key')
link = client_v1.links.get('link_token')
puts link.accounts

# Or... you can pretty print all the accounts in a Link

link = client_v1.links.get('link_token')
link.show_accounts

```

If you want to find a specific account in a link, you can use **find**. You can search by any account field:

```ruby
require 'fintoc'

client = Fintoc::V1::Client.new('api_key')
link = client_v1.links.get('link_token')
account = link.find(type: 'checking_account')

# Or by number
account = link.find(number: '1111111')

# Or by account id
account = link.find(id: 'sdfsdf234')
```

You can also search for multiple accounts matching a specific criteria with **find_all**:

```ruby
require 'fintoc'

client = Fintoc::V1::Client.new('api_key')
link = client_v1.links.get('link_token')
accounts = link.find_all(currency: 'CLP')
```

To update the account balance you can use **update_balance**:

```ruby
require 'fintoc'

client = Fintoc::V1::Client.new('api_key')
link = client_v1.links.get('link_token')
account = link.find(number: '1111111')
account.update_balance
```

#### Get movements

```ruby
require 'fintoc'
require 'time'

client = Fintoc::V1::Client.new('api_key')
link = client_v1.links.get('link_token')
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

client_v2 = Fintoc::V2::Client.new('api_key', 'jws_private_key')

# Get all entities
entities = client_v2.entities.list

# Get a specific entity
entity = client_v2.entities.get('entity_id')
```

You can also list entities with pagination:

```ruby
# Get entities with pagination
entities = client_v2.entities.list(limit: 10, starting_after: 'entity_id')
```

#### Transfer Accounts

```ruby
require 'fintoc'

client_v2 = Fintoc::V2::Client.new('api_key', 'jws_private_key')

# Create a transfer account
account = client_v2.accounts.create(
  entity_id: 'entity_id',
  description: 'My Business Account'
)

# Get a specific account
account = client_v2.accounts.get('account_id')

# List all accounts
accounts = client_v2.accounts.list

# Update an account
updated_account = client_v2.accounts.update('account_id', description: 'Updated Description')
```

#### Account Numbers

```ruby
require 'fintoc'

client_v2 = Fintoc::V2::Client.new('api_key', 'jws_private_key')

# Create an account number
account_number = client_v2.account_numbers.create(
  account_id: 'account_id',
  description: 'Main account number'
)

# Get a specific account number
account_number = client_v2.account_numbers.get('account_number_id')

# List all account numbers
account_numbers = client_v2.account_numbers.list

# Update an account number
updated_account_number = client_v2.account_numbers.update(
  'account_number_id',
  description: 'Updated account number'
)
```

#### Transfers

```ruby
require 'fintoc'

client_v2 = Fintoc::V2::Client.new('api_key', 'jws_private_key')

# Create a transfer
transfer = client_v2.transfers.create(
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
transfer = client_v2.transfers.get('transfer_id')

# List all transfers
transfers = client_v2.transfers.list

# Return a transfer
returned_transfer = client_v2.transfers.return('transfer_id')
```

#### Simulate

```ruby
require 'fintoc'

client_v2 = Fintoc::V2::Client.new('api_key', 'jws_private_key')

# Simulate receiving a transfer
simulated_transfer = client_v2.simulate.receive_transfer(
  account_number_id: 'account_number_id',
  amount: 5000,
  currency: 'CLP'
)
```

#### Account Verifications

```ruby
require 'fintoc'

client_v2 = Fintoc::V2::Client.new('api_key', 'jws_private_key')

# Create an account verification
account_verification = client_v2.account_verifications.create(account_number: 'account_number')

# Get a specific account verification
account_verification = client_v2.account_verifications.get('account_verification_id')

# List all account verifications
account_verifications = client_v2.account_verifications.list
```

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
