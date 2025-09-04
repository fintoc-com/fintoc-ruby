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
    - [**Movements API Client**](#movements-api-client)
    - [**Transfers API Client**](#transfers-api-client)
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
      - [Simulation](#simulation)
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

movements_client =
  Fintoc::Movements::Client.new('sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx')
link = movements_client.get_link('6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W')
account = link.find(type: 'checking_account')

# Get the last 30 movements
movements = account.get_movements

# Or get all the movements since a specific date
movements = account.get_movements(since: '2020-08-15')
```

And that’s it!

## Client Architecture

The Fintoc Ruby client is organized into separate clients that mirror the official API structure:

### **Movements API Client**

The Movements API client provides access to bank account data and movements:

```ruby
movements_client = Fintoc::Movements::Client.new('api_key')

# Link management
links = movements_client.get_links
link = movements_client.get_link('link_token')
movements_client.delete_link('link_id')

# Account access
account = movements_client.get_account('link_token', 'account_id')
```

### **Transfers API Client**

The Transfers API client provides access to transfer accounts, entities, and transfer operations:

```ruby
transfers_client = Fintoc::Transfers::Client.new('api_key')

# Entities
entities = transfers_client.get_entities
entity = transfers_client.get_entity('entity_id')

# Transfer Accounts
accounts = transfers_client.list_accounts
account = transfers_client.get_account('account_id')
account = transfers_client.create_account(entity_id: 'entity_id', description: 'My Account')
transfers_client.update_account('account_id', description: 'Updated')

# Account Numbers
account_numbers = transfers_client.list_account_numbers
account_number = transfers_client.get_account_number('account_number_id')
account_number = transfers_client.create_account_number(account_id: 'account_id', description: 'Main')
transfers_client.update_account_number('account_number_id', description: 'Updated')

# Transfers
transfers = transfers_client.list_transfers
transfer = transfers_client.get_transfer('transfer_id')
transfer = transfers_client.create_transfer(amount: 1000, currency: 'CLP', account_id: 'account_id', counterparty: {...})
transfers_client.return_transfer('transfer_id')

# Simulation
simulation = transfers_client.simulate_receive_transfer(account_number_id: 'account_number_id', amount: 1000, currency: 'CLP')

# Account Verifications
account_verifications = transfers_client.list_account_verifications
account_verification = transfers_client.get_account_verification('account_verification_id')
account_verification = transfers_client.create_account_verification(account_number: 'account_number')
```

### **Backward compatibility**

The previous `Fintoc::Client` class is kept for backward compatibility purposes.

```ruby
client = Fintoc::Client.new('api_key')

links = client.get_links
```

## Documentation

This client supports all Fintoc API endpoints. For complete information about the API, head to the [docs](https://docs.fintoc.com/reference).

## Examples

### Movements API Examples

#### Get accounts

```ruby
require 'fintoc'

client = Fintoc::Movements::Client.new('api_key')
link = client.get_link('link_token')
puts link.accounts

# Or... you can pretty print all the accounts in a Link

link = client.get_link('link_token')
link.show_accounts

```

If you want to find a specific account in a link, you can use **find**. You can search by any account field:

```ruby
require 'fintoc'

client = Fintoc::Movements::Client.new('api_key')
link = client.get_link('link_token')
account = link.find(type: 'checking_account')

# Or by number
account = link.find(number: '1111111')

# Or by account id
account = link.find(id: 'sdfsdf234')
```

You can also search for multiple accounts matching a specific criteria with **find_all**:

```ruby
require 'fintoc'

client = Fintoc::Movements::Client.new('api_key')
link = client.get_link('link_token')
accounts = link.find_all(currency: 'CLP')
```

To update the account balance you can use **update_balance**:

```ruby
require 'fintoc'

client = Fintoc::Movements::Client.new('api_key')
link = client.get_link('link_token')
account = link.find(number: '1111111')
account.update_balance
```

#### Get movements

```ruby
require 'fintoc'
require 'time'

client = Fintoc::Movements::Client.new('api_key')
link = client.get_link('link_token')
account = link.find(type: 'checking_account')

# You can get the account movements since a specific DateTime
yesterday = DateTime.now - 1
account.get_movements(since: yesterday)

# Or you can use an ISO 8601 formatted string representation of the Date
account.get_movements(since: '2020-01-01')

# You can also set how many movements you want per_page
account.get_movements(since: '2020-01-01', per_page: 100)
```

Calling **get_movements** without arguments gets the last 30 movements of the account

### Transfers API Examples

#### Entities

```ruby
require 'fintoc'

client = Fintoc::Transfers::Client.new('api_key')

# Get all entities
entities = client.get_entities

# Get a specific entity
entity = client.get_entity('entity_id')

puts entity.holder_name  # => "My Company LLC"
puts entity.holder_id    # => "12345678-9"
puts entity.is_root      # => true
```

You can also list entities with pagination:

```ruby
# Get entities with pagination
entities = client.get_entities(limit: 10, starting_after: 'entity_id')
```

#### Transfer Accounts

```ruby
require 'fintoc'

client = Fintoc::Transfers::Client.new('api_key')

# Create a transfer account
account = client.create_account(
  entity_id: 'entity_id',
  description: 'My Business Account'
)

# Get a specific account
account = client.get_account('account_id')

# List all accounts
accounts = client.list_accounts

# Update an account
updated_account = client.update_account('account_id', description: 'Updated Description')
```

#### Account Numbers

```ruby
require 'fintoc'

client = Fintoc::Transfers::Client.new('api_key')

# Create an account number
account_number = client.create_account_number(
  account_id: 'account_id',
  description: 'Main account number'
)

# Get a specific account number
account_number = client.get_account_number('account_number_id')

# List all account numbers
account_numbers = client.list_account_numbers

# Update an account number
updated_account_number = client.update_account_number(
  'account_number_id',
  description: 'Updated account number'
)
```

#### Transfers

```ruby
require 'fintoc'

client = Fintoc::Transfers::Client.new('api_key')

# Create a transfer
transfer = client.create_transfer(
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
transfer = client.get_transfer('transfer_id')

# List all transfers
transfers = client.list_transfers

# Return a transfer
returned_transfer = client.return_transfer('transfer_id')
```

#### Simulation

```ruby
require 'fintoc'

client = Fintoc::Transfers::Client.new('api_key')

# Simulate receiving a transfer
simulation = client.simulate_receive_transfer(
  account_number_id: 'account_number_id',
  amount: 5000,
  currency: 'CLP'
)
```

#### Account Verifications

```ruby
require 'fintoc'

client = Fintoc::Transfers::Client.new('api_key')

# Create an account verification
account_verification = client.create_account_verification(account_number: 'account_number')

# Get a specific account verification
account_verification = client.get_account_verification('account_verification_id')

# List all account verifications
account_verifications = client.list_account_verifications
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
