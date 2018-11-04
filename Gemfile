# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# These gems are only used by tests - we need to have these gems available in
# the current Bundler context (i.e. the context used when running tests) to
# allow us to use Bundler to locate gem sources etc., otherwise we would need to
# stub Bundler to hell. With Bundler being so integral to BundleHack I don't
# think that's an option.
gem 'another_dummy_gem',
    git: 'https://github.com/bobf/another_dummy_gem', ref: 'ed0e5d21f1ff'
gem 'dummy_gem', '1.0.0'
gem 'noop', '0.0.2'

gemspec
