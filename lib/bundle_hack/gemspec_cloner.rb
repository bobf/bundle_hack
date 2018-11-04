module BundleHack
  class GemspecCloner
    def initialize(gem, root_path)
      @gem_name = gem.fetch(:name)
      @gem_version = gem.fetch(:version)
      @root_path = root_path
      @spec_path = @root_path.join(HACK_DIR, @gem_name, "#{@gem_name}.gemspec")
    end

    def clone
      FileUtils.mkdir_p(@root_path.join(HACK_DIR, @gem_name))
      File.write(@spec_path, spec.to_ruby)
    end

    private

    def dependency
      Gem::Dependency.new(@gem_name, @gem_version)
    end

    def spec
      # Borrowed from:
      # https://ruby-doc.org/stdlib-2.5.3/libdoc/rubygems/rdoc/Gem.html#method-c-latest_spec_for
      # TODO: Try to get this from cache rather than hitting rubygems
      spec_tuples, = Gem::SpecFetcher.fetcher.spec_for_dependency(dependency)
      spec, = spec_tuples.first
      spec
    end
  end
end
