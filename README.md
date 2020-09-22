# Fintoc

# Fintoc meets Ruby 

[![Version](https://img.shields.io/npm/v/fintoc.svg)](https://www.npmjs.org/package/fintoc)
[![Try on RunKit](https://badge.runkitcdn.com/fintoc.svg)](https://runkit.com/npm/fintoc)

You have just found the [Ruby](https://www.ruby-lang.org/)-flavored client of [Fintoc](https://fintoc.com). It mainly consists of a port (more of a carbon copy, really) of [fintoc-python](https://github.com/fintoc-com/fintoc-python).

## Why?

You can think of [Fintoc API](https://fintoc.com/docs) as a piscola.
And the key ingredient to a properly made piscola are the ice cubes.  
Sure, you can still have a [piscola without ice cubes](https://curl.haxx.se/).
But hey… that’s not enjoyable -- why would you do that?  
Do yourself a favor: go grab some ice cubes by installing this refreshing library.

## Table of contents

- [Fintoc meets Ruby](#fintoc-meets-ruby)
  - [Table of contents](#table-of-contents)
  - [How to install](#how-to-install)
  - [Quickstart](#quickstart)
  - [Documentation](#documentation)
  - [Examples](#examples)
    - [Get accounts](#get-accounts)
    - [Get movements](#get-movements)
  - [Dependencies](#dependencies)
  - [How to test…](#how-to-test)
  - [Roadmap](#roadmap)
  - [Acknowledgements](#acknowledgements)


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

client = Fintoc::Client.new('api_key')
link = client.link('link_token')
account = link.find(type: 'checking_account')

#Get the las 30 movements
movements = account.get_movements

#Or get the all the movements since 
movements = account.get_movements(since: '2020-08-15')

```
And that’s it!
## Documentation

## Examples

### Get accounts

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key')
link = client.get_link('link_token')
accounts = link.get_accounts
puts accounts

# Or... you can pretty print all the accounts in a Link

link = client.get_link('link_token')
link.show_accounts

```

If you want to find a specific account in a link, you can use **find**. You can search by any account field:

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key')
link = client.get_link('link_token')
account = link.find(type: 'checking_account')

# or 
account = link.find(number: '1111111')

# or

account = link.find(id: 'sdfsdf234')
```

You can also search for multiple accounts matching a specific criteria with **find_all**:

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key')
link = client.get_link('link_token')
accounts = link.find_all(currency: 'CLP')
```

To update the account balance you can use **update_balance**:

```ruby
require 'fintoc'

client = Fintoc::Client.new('api_key')
link = client.get_link('link_token')
account = link.find(number: '1111111')
account.update_balance

```
### Get movements

```ruby
require 'fintoc'
require 'time'

client = Fintoc::Client.new('api_key')
link = client.get_link('link_token')
account = link.find(type: 'checking_account')

# You can get the account movements since a specific Date
yesterday = DateTime.now - 1
account.get_movements(since: yesterday)

# Or... you can use an ISO 8601 formatted string representation of the Date
account.get_movements(since: '2020-01-01')
```

Calling **get_movements** without arguments gets the last 30 movements of the account

## Dependencies

This project relies on the following packages:

- [**http.rb**](https://github.com/httprb/http)
- [**tabulate**](https://github.com/roylez/tabulate)

## How to test…

You can run all the tests just by running:

```
rspec
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fintoc-com/fintoc.

