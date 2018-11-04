module BundleHack
  class GemCloner
    def initialize(gem, root_path)
      @gem_name = gem.fetch(:name)
      @gem_path = gem.fetch(:path)
      @gem_full_name = gem.fetch(:full_name)
      @root_path = root_path
    end

    def clone
      hack_dir = @root_path.join(HACK_DIR)
      target_dir = hack_dir.join(@gem_name)

      FileUtils.mkdir_p(hack_dir)
      # Sadly there is no `FileUtils.cp_R` so we copy and rename instead
      FileUtils.cp_r(@gem_path, hack_dir)
      FileUtils.mv(hack_dir.join(@gem_full_name), hack_dir.join(@gem_name))
    end
  end
end

