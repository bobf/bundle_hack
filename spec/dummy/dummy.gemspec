# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'dummy_app'
  spec.version       = '1.0.0'
  spec.authors       = ['Dummy Author']

  spec.summary       = 'Dummy Application'

  spec.add_dependency 'dummy_gem', '1.0.0'
  spec.add_dependency 'noop', '0.0.2'
end
