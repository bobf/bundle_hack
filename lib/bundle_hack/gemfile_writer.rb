# frozen_string_literal: true

module BundleHack
  class GemfileWriter
    def initialize(root_path, gemfile_path, options = {})
      @root_path = root_path
      @gemfile_path = gemfile_path
      @comment_lines = options.fetch(:comment_lines)
      @hacked_gems = options.fetch(:hacked_gems)
      @hacked_gemfile_path = @root_path.join(GEMFILE)
    end

    def create
      comment_existing_gems
      append_hacked_gems
    end

    private

    def comment_existing_gems
      File.write(@hacked_gemfile_path, commented_gemfile)
    end

    def commented_gemfile
      File.readlines(@gemfile_path).to_enum.with_index(1).map do |line, index|
        next line.chomp unless @comment_lines.include?(index)

        "# #{line.chomp} # managed by BundleHack"
      end.join("\n")
    end

    def append_hacked_gems
      File.write(
        @hacked_gemfile_path,
        File.read(@hacked_gemfile_path) + header + hacked_gem_definitions
      )
    end

    def hacked_gem_definitions
      @hacked_gems.map do |gem_name|
        # TODO: Retain original non-path (:git, :path) parameters
        "gem '#{gem_name}', path: 'hack/#{gem_name}'"
      end.join("\n")
    end

    def header
      File.read(BundleHack.root.join('config', 'header.rb'))
    end
  end
end
