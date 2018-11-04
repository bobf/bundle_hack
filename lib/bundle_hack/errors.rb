module BundleHack
  class BundleHackError < StandardError; end
  class MissingGemError < BundleHackError; end
  class MissingSpecError < BundleHackError; end
  class ParsingError < BundleHackError; end
end
