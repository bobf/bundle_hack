# frozen_string_literal: true

module BundleHack
  class GemLocator
    def initialize(gemfile_path, gemfile_lock_path)
      @gemfile_path = gemfile_path
      @gemfile_lock_path = gemfile_lock_path
    end

    def locate(gem_name)
      gem = gems.find { |spec| spec[:name] == gem_name }
      missing_gem_error(gem_name) if gem.nil?

      BundleHack::Gem.new(gem)
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
        version: spec.version
      }
    end

    def bundler_specs
      @bundler_specs ||= Bundler::Definition.build(
        @gemfile_path, @gemfile_lock_path, nil
      ).specs
    end
  end
end
