lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mockly/version'

Gem::Specification.new do |s|
  s.name        = 'mockly'
  s.version     = Mockly::VERSION
  s.summary     = 'File based API mock server'
  s.description = 'Set up a testing server using a directory structure'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*', 'app/**/*']
  s.executables = ['mockly']
  s.homepage    = 'https://github.com/DannyBen/mockly'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'json', '~> 2.18'
  s.add_dependency 'mime-types', '~> 3.6'
  s.add_dependency 'mister_bin', '~> 0.7'
  s.add_dependency 'puma', '~> 7.1'
  s.add_dependency 'rackup', '~> 2.1'
  s.add_dependency 'sinatra', '~> 4.2'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/mockly/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/mockly/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/DannyBen/mockly',
    'rubygems_mfa_required' => 'true',
  }
end
