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
      parser = GemfileParser.new(File.open(@gemfile_path))
      gems = locate_gems(parser)
      ConfigWriter.new(@root_path).create_or_update
      GemfileWriter.new(@root_path, @gemfile_path, gems).create
      gems.each do |gem|
        GemCloner.new(gem, @root_path).clone
        GemspecCloner.new(gem, @root_path).clone
      end
    end

    private

    def locate_gems(parser)
      # TODO: Read from .bundle_hack.yml
      [@gem_name].map { |gem_name| locate_gem(gem_name, parser) }
    end

    def locate_gem(gem_name, parser)
      GemLocator.new(@gemfile_path, @gemfile_lock_path)
                .locate(gem_name)
                .update(parser.definition_for(gem_name))
    end

    def lock_path(gemfile_path)
      gemfile_path.nil? ? Bundler.default_lockfile : "#{gemfile_path}.lock"
    end
  end
end
