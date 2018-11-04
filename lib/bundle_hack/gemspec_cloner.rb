module BundleHack
  class GemspecCloner
    def initialize(gem, root_path)
      @gem_name = gem.fetch(:name)
      @gem_version = gem.fetch(:version)
      @gem_path = Pathname.new(gem.fetch(:path))
      @root_path = root_path
      @spec_path = @root_path.join(HACK_DIR, @gem_name, "#{@gem_name}.gemspec")
    end

    def clone
      FileUtils.mkdir_p(@root_path.join(HACK_DIR, @gem_name))
      File.write(@spec_path, spec_for(gem_dependency))
    end

    private

    def gem_dependency
      Gem::Dependency.new(@gem_name, @gem_version)
    end

    def spec_for(dependency)
      return path_spec unless path_spec.nil?

      # Borrowed from:
      # https://ruby-doc.org/stdlib-2.5.3/libdoc/rubygems/rdoc/Gem.html#method-c-latest_spec_for
      # TODO: Try to get this from cache rather than hitting rubygems
      spec_tuples, = Gem::SpecFetcher.fetcher.spec_for_dependency(dependency)
      spec, = spec_tuples.first
      spec.to_ruby
    end

    def path_spec
      # If the gem comes from a path (including git) then we will have the
      # gemspec available in the same directory.
      @path_spec ||= begin
        gemspec_path = @gem_path.join("#{@gem_name}.gemspec")
        return nil unless File.exist?(gemspec_path)

        File.read(gemspec_path)
      end
    end
  end
end
