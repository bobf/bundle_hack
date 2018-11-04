# frozen_string_literal: true

module BundleHack
  class Sandbox
    def initialize(gem_name, gemfile_path = nil)
      @gem_name = gem_name
      @gemfile_path = gemfile_path || Bundler.default_gemfile
      @gemfile_lock_path = lock_path(gemfile_path)
      @root_path = Pathname.new(File.dirname(@gemfile_path))
    end

    def build
      gem = GemLocator.new(@gemfile_path, @gemfile_lock_path).locate(@gem_name)
      parser = GemfileParser.new(File.open(@gemfile_path))
      ConfigWriter.new(@root_path).create_or_update
      GemfileWriter.new(@root_path, @gemfile_path, write_options(parser)).create
      GemCloner.new(gem, @root_path).clone
      GemspecCloner.new(gem, @root_path).clone
    end

    private

    def write_options(parser)
      {
        comment_lines: comment_lines(parser),
        hacked_gems: [@gem_name] # TODO: Read from .bundle_hack.yml
      }
    end

    def lock_path(gemfile_path)
      gemfile_path.nil? ? Bundler.default_lockfile : "#{gemfile_path}.lock"
    end

    def comment_lines(parser)
      # TODO: Read from .bundle_hack.yml
      [@gem_name].map { |gem_name| parser.line_numbers_for(gem_name) }.flatten
    end
  end
end
