# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require File.expand_path('../lib/aws/client/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Hakan Ensari']
  gem.email         = ['hakan.ensari@papercavalier.com']
  gem.description   = %q{An abstract client to Amazon Web Services (AWS) APIs}
  gem.summary       = %q{Amazon Web Services client}
  gem.homepage      = 'https://github.com/hakanensari/aws-client'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'aws-client'
  gem.require_paths = ['lib']
  gem.version       = AWS::Client::VERSION

  gem.add_runtime_dependency     'faraday',  '~> 0.8.0'
  gem.add_runtime_dependency     'nokogiri', '~> 1.5'
  gem.add_development_dependency 'rake',     '~> 0.9'
  gem.add_development_dependency 'rspec',    '~> 2.9'
end
