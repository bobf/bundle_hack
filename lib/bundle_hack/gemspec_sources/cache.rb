# frozen_string_literal: true

module BundleHack
  module GemspecSources
    # I couldn't figure out how to do this with `Gem` directly so I've
    # implemented it myself instead - if this can be collapsed into something
    # along the lines of `Gem.from_cache(gem_name, gem_version)` then that would
    # mean all of this code can go away.
    class Cache < Base
      def spec
        path = cache_file_path
        return nil if path.nil?

        # rubocop:disable Security/MarshalLoad
        Marshal.load(File.read(cache_file_path)).to_ruby
        # rubocop:enable Security/MarshalLoad
      end

      private

      def cache_file_path
        cache_dirs.each do |cache_dir|
          cache_file_path = cache_dir.join("#{@gem.full_name}.gemspec")
          return cache_file_path if File.exist?(cache_file_path)
        end

        nil
      end

      def cache_dirs
        Dir.entries(base_dir)
           .select { |path| File.directory?(quick_cache(path)) }
           .reject { |path| %w[. ..].include?(path) }
           .map { |path| quick_cache(path) }
      end

      def quick_cache(path)
        # I think the `4.8` versioning is highly stable. The lead dev of
        # Bundler references it in this post from nearly 5 years ago:
        # https://www.engineyard.com/blog/new-rubygems-index-format
        # So I think # it's okay to make this a hard requirement.
        base_dir.join(path, 'quick', 'Marshal.4.8')
      end

      def base_dir
        @base_dir ||= Pathname.new(::Gem.spec_cache_dir)
      end
    end
  end
end
