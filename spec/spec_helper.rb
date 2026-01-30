require 'simplecov'
SimpleCov.start

unless ENV['NOCOV']
  SimpleCov.start do
    enable_coverage :branch if ENV['BRANCH_COV']
    coverage_dir 'spec/coverage'
  end
end

require 'bundler'
Bundler.require :default, :development, :test

require 'mockserver'

# Consistent Colsole output (for rspec_fixtures)
ENV['TTY'] = 'off'
ENV['COLUMNS'] = '80'
ENV['LINES'] = '30'

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/status.txt'
  config.strip_ansi_escape = true
  config.filter_run_excluding :noci if ENV['CI']
end
