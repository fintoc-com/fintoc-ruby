require_relative 'lib/fintoc/version'

Gem::Specification.new do |spec|
  spec.name          = 'fintoc'
  spec.version       = Fintoc::VERSION
  spec.summary       = 'The official Ruby client for the Fintoc API.'
  spec.description   = 'The official Ruby client for the Fintoc API.'
  spec.authors       = ['Daniel Leal', 'Juan Ca Sardin']
  spec.email         = ['daniel@fintoc.com']
  spec.license       = 'BSD-3-Clause'

  spec.homepage      = 'https://fintoc.com'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fintoc-com/fintoc-ruby'

  spec.files = Dir['lib/**/*.rb']

  # Library Dependencies
  spec.add_dependency 'faraday', '~> 1.8'
  spec.add_dependency 'faraday_middleware', '~> 1.2'

  # Development Dependencies
  spec.add_development_dependency 'rubocop', '~> 1.23'
end
