# frozen_string_literal: true

require 'pathname'
require 'yaml'

require 'i18n'
require 'parser/current'

require 'bundle_hack/command'
require 'bundle_hack/config_writer'
require 'bundle_hack/errors'
require 'bundle_hack/gem_cloner'
require 'bundle_hack/gem_locator'
require 'bundle_hack/gemfile_parser'
require 'bundle_hack/gemfile_writer'
require 'bundle_hack/gemspec_cloner'
require 'bundle_hack/sandbox'
require 'bundle_hack/version'

I18n.config.available_locales = :en
I18n.load_path += Dir[
  File.join(File.expand_path('..', __dir__), 'config', 'locales', '**', '*.yml')
]

module BundleHack
  GEMFILE = 'Gemfile.hack'
  HACK_DIR = 'hack'

  def self.root
    Pathname.new(File.dirname(__dir__))
  end
end
