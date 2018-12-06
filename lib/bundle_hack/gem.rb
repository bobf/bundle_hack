# frozen_string_literal: true

module BundleHack
  class Gem
    attr_reader :name, :full_name, :version, :path

    def initialize(definitions, options = {})
      @definitions = definitions
      @name = options.fetch(:name)
      @full_name = options.fetch(:full_name)
      @version = normalized_version(options.fetch(:version))
      @path = Pathname.new(options.fetch(:path))
    end

    def locations
      @definitions.map { |definition| definition[:locations] }.flatten
    end

    def params
      find_params || {}
    end

    private

    def find_params
      # Because we don't know how the bundle was built (e.g. if it was built
      # with `--without development test`) we have to take a guess at which
      # definition to use for our parameters. In most cases the definition will
      # be in the main block, otherwise we use the `development` definition and,
      # failing that, we take the definition nearest to the end of the Gemfile.
      # This is very much an edge case as this will only be a problem if we pick
      # the wrong one AND the parameters are different to the "real" gem we're
      # using.
      return primary_definition[:params] unless primary_definition.nil?
      return development_definition[:params] unless development_definition.nil?

      any_definition[:params]
    end

    def primary_definition
      @definitions.reverse_each.find do |definition|
        definition.fetch(:group).nil?
      end
    end

    def development_definition
      @definitions.reverse_each.find do |definition|
        definition.fetch(:group) == :development
      end
    end

    def any_definition
      @definitions.last
    end

    def normalized_version(version)
      # Ruby >= 2.3.0: `version` is a `Gem::Version`
      # Ruby < 2.3.0: `version` is a `String`
      version.respond_to?(:version) ? version.version : version
    end
  end
end
