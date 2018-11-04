# frozen_string_literal: true

module BundleHack
  class ConfigWriter
    def initialize(root_path)
      @root_path = root_path
      @config_path = File.join(@root_path, '.bundle', 'config')
    end

    def create_or_update
      return create_config unless File.exist?(@config_path)

      update_config
    end

    private

    def create_config
      FileUtils.mkdir_p(File.join(@root_path, '.bundle'))
      write_config(config_settings)
    end

    def update_config
      write_config(YAML.load_file(@config_path).merge(config_settings))
    end

    def write_config(config)
      File.write(@config_path, config.to_yaml)
    end

    def config_settings
      {
        'BUNDLE_GEMFILE' => GEMFILE
      }
    end
  end
end
