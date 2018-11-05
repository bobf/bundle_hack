# frozen_string_literal: true

module BundleHack
  class Gem
    attr_reader :name, :full_name, :version, :path, :locations, :params

    def initialize(options = {})
      @name = options.fetch(:name)
      @full_name = options.fetch(:full_name)
      @version = normalized_version(options.fetch(:version))
      @path = Pathname.new(options.fetch(:path))
    end

    def update(options = {})
      @locations = options[:locations] if options.key?(:locations)
      @params = options[:params] if options.key?(:params)

      self
    end

    private

    def normalized_version(version)
      # Ruby >= 2.3.0: `version` is a `Gem::Version`
      # Ruby < 2.3.0: `version` is a `String`
      version.respond_to?(:version) ? version.version : version
    end
  end
end
