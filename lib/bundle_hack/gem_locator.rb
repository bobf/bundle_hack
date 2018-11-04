module BundleHack
  class GemLocator
    def initialize(gemfile_path, gemfile_lock_path)
      @gemfile_path = gemfile_path
      @gemfile_lock_path = gemfile_lock_path
    end

    def locate(gem_name)
      gem = gems.find { |gem| gem[:name] == gem_name }
      missing_gem_error(gem_name) if gem.nil?

      gem
    end

    private

    def gems
      bundler_specs.map do |spec|
        filtered_spec(spec)
      end
    end

    def missing_gem_error(gem_name)
      raise MissingGemError, I18n.t('errors.missing_gem', gem: gem_name)
    end

    def filtered_spec(spec)
      {
        name: spec.name,
        full_name: spec.full_name,
        path: spec.full_gem_path,
        version: spec_version(spec)
      }
    end

    def bundler_specs
      @bundler_specs ||= Bundler::Definition.build(
        @gemfile_path, @gemfile_lock_path, nil
      ).specs
    end

    def spec_version(spec)
      # Ruby >= 2.3.0: `version_obj` is a `Gem::Version`
      # Ruby < 2.3.0: `version_obj` is a `String`
      spec.version.respond_to?(:version) ? spec.version.version : spec.version
    end
  end
end
