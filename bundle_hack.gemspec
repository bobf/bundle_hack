# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundle_hack/version'

Gem::Specification.new do |spec|
  spec.name          = 'bundle_hack'
  spec.version       = BundleHack::VERSION
  spec.authors       = ['Bob Farrell']
  spec.email         = ['robertanthonyfarrell@gmail.com']

  spec.summary       = 'Safely hack gems in your bundle'
  spec.description   = "Debug fearlessly and restore when you're done"
  spec.homepage      = 'http://github.com/bobf/bundle_hack'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.59.2'
end
