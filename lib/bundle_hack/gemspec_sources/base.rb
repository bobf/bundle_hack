module BundleHack
  module GemspecSources
    class Base
      def initialize(gem)
        @gem = gem
      end

      def spec
        raise NotImplementedError
      end
    end
  end
end
