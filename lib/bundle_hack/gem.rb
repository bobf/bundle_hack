# frozen_string_literal: true

module BundleHack
  class Gem
    attr_reader :name, :full_name, :version, :path

    def initialize(options = {})
      @name = options.fetch(:name)
      @full_name = options.fetch(:full_name)
      @version = normalized_version(options.fetch(:version))
      @path = Pathname.new(options.fetch(:path))
    end

    private

    def normalized_version(version)
      # Ruby >= 2.3.0: `version` is a `Gem::Version`
      # Ruby < 2.3.0: `version` is a `String`
      version.respond_to?(:version) ? version.version : version
    end
  end
end
