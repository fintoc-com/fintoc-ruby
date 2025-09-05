source 'https://rubygems.org'

# Specify your gem's dependencies in fintoc.gemspec
gemspec

# Development dependencies
group :development do
  gem 'rubocop', '~> 1.80'
  gem 'rubocop-capybara', '~> 2.22', '>= 2.22.1'
  gem 'rubocop-performance', '~> 1.25'
  gem 'rubocop-rails', '~> 2.33', '>= 2.33.3'
  gem 'rubocop-rspec', '~> 3.6'
end

group :test do
  gem 'rexml'  # Required for webmock in Ruby 3.0+
  gem 'rspec', '~> 3.0'
  gem 'simplecov', '~> 0.21'
  gem 'simplecov_linter_formatter'
  gem 'simplecov_text_formatter'
  gem 'vcr', '~> 6.3'
  gem 'webmock'
end
