# frozen_string_literal: true

module BundleHack
  class GemCloner
    def initialize(gem, root_path)
      @gem = gem
      @root_path = root_path
    end

    def clone
      hack_dir = @root_path.join(HACK_DIR)

      FileUtils.mkdir_p(hack_dir)
      # Sadly there is no `FileUtils.cp_R` so we copy and rename instead
      FileUtils.cp_r(@gem.path, hack_dir)
      FileUtils.mv(hack_dir.join(@gem.full_name), hack_dir.join(@gem.name))
    end
  end
end
