module BundleHack
  module GemspecSources
    class Rubygems < Base
      def spec
        dependency = ::Gem::Dependency.new(@gem.name, @gem.version)

        # Borrowed from:
        # https://ruby-doc.org/stdlib-2.5.3/libdoc/rubygems/rdoc/Gem.html#method-c-latest_spec_for
        spec_tuples, = ::Gem::SpecFetcher.fetcher.spec_for_dependency(
          dependency
        )
        spec, = spec_tuples.first
        return nil if spec.nil?

        spec.to_ruby
      end
    end
  end
end
