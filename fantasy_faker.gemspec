# frozen_string_literal: true

require_relative 'lib/fantasy_faker/version'

Gem::Specification.new do |spec|
  spec.name = 'fantasy_faker'
  spec.version = FantasyFaker::VERSION
  spec.authors = ['Konrad Jurkowski']
  spec.email = ['konrad@jurkowski.me']
  spec.description = 'Generate fake random data for fantasy-climate projects'
  spec.summary = 'Fantasy Faker, generates dummy data.'
  spec.homepage = 'https://github.com/msx2/fantasy_faker'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0'

  spec.files = Dir['lib/**/*.rb', 'locales/**/*.yml', 'README.md', 'CHANGELOG.md', 'LICENSE.txt']
  spec.require_paths = ['lib']
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'
end
