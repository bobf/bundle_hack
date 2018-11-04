# frozen_string_literal: true

module BundleHack
  class GemspecCloner
    def initialize(gem, root_path, options = {})
      @use_cache = options.fetch(:use_cache, true)
      @use_rubygems = options.fetch(:use_rubygems, true)
      @gem = gem
      @root_path = root_path
      @spec_path = @root_path.join(HACK_DIR, @gem.name, "#{@gem.name}.gemspec")
    end

    def clone
      FileUtils.mkdir_p(@root_path.join(HACK_DIR, @gem.name))
      File.write(@spec_path, find_spec)
    end

    private

    def find_spec
      return path_spec unless path_spec.nil?
      return cache_spec unless cache_spec.nil?
      return rubygems_spec unless rubygems_spec.nil?

      raise MissingSpecError, I18n.t('errors.missing_spec', gem: @gem.name)
    end

    def spec_from(source)
      source.new(@gem).spec
    end

    def rubygems_spec
      return nil unless @use_rubygems

      @rubygems_spec ||= spec_from(GemspecSources::Rubygems)
    end

    def path_spec
      @path_spec ||= spec_from(GemspecSources::Path)
    end

    def cache_spec
      return nil unless @use_cache

      @cache_spec ||= spec_from(GemspecSources::Cache)
    end
  end
end
