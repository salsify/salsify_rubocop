# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'salsify_rubocop/version'

Gem::Specification.new do |spec|
  spec.name          = 'salsify_rubocop'
  spec.version       = SalsifyRubocop::VERSION
  spec.authors       = ['Salsify, Inc']
  spec.email         = ['engineering@salsify.com']

  spec.summary       = 'Shared shared RuboCop configuration'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/salsify/salsify_rubocop'

  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_runtime_dependency 'rubocop', '~> 0.91.0'
  spec.add_runtime_dependency 'rubocop-performance', '~> 1.5.0'
  spec.add_runtime_dependency 'rubocop-rails', '~> 2.4.0'
  spec.add_runtime_dependency 'rubocop-rspec', '~> 1.37.0'
end
