# frozen_string_literal: true

module BundleHack
  module GemspecSources
    class Path < Base
      def spec
        # If the gem comes from a path (including git) then we will have the
        # gemspec available in the gem directory (unlike when it comes from
        # rubygems)
        gemspec_path = @gem.path.join("#{@gem.name}.gemspec")
        return nil unless File.exist?(gemspec_path)

        File.read(gemspec_path)
      end
    end
  end
end
