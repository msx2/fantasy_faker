# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fantasy_faker'

Gem::Specification.new do |spec|
  spec.name          = 'fantasy_faker'
  spec.version       = FantasyFaker::VERSION
  spec.authors       = ['Konrad Jurkowski']
  spec.email         = ['konrad@jurkowski.me']
  spec.description   = 'Fantasy Faker, generates dummy data.'
  spec.summary       = 'Fantasy Faker, generates dummy data.'
  spec.homepage      = 'https://github.com/msx2/fantasy_faker'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
