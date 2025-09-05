if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'simplecov_text_formatter'
  require 'simplecov_linter_formatter'

  SimpleCov.start do
    formatter SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter])

    add_filter '/vendor/'
    add_filter '/lib/fintoc.rb'
    add_filter '/lib/fintoc/version.rb'
    add_filter '/lib/tasks/simplecov_config.rb'

    track_files 'lib/**/*.rb'

    minimum_coverage 100
    minimum_coverage_by_file 100
  end
end
