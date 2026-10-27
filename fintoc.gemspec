require_relative 'lib/fintoc/version'

Gem::Specification.new do |spec|
  spec.name          = 'fintoc'
  spec.version       = Fintoc::VERSION
  spec.authors       = ['Juan Ca Sardin']
  spec.email         = ['juan.carlos.sardin@gmail.com']

  spec.summary       = 'The official Ruby client for the Fintoc API.'
  spec.description   = 'The official Ruby client for the Fintoc API.'
  spec.homepage      = 'https://github.com/fintoc-com/fintoc-ruby'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.2.2')

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fintoc-com/fintoc-ruby'
  spec.metadata['rubygems_mfa_required'] = 'true'
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{\A(?:(?:test|spec|features|\.agents|\.claude)/|(?:AGENTS|CLAUDE)\.md\z)})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'http'
  spec.add_dependency 'money-rails'
  spec.add_dependency 'tabulate'
end
