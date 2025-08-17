module Onefig
  class SourceRegistry
    def initialize
      @sources = []
    end

    def registered_sources
      @sources
    end

    def add_source(source_type, options = {})
      source_method = "add_#{source_type}_source".to_sym
      raise "Unknown source type: #{source_type}" unless respond_to?(source_method)
      send(source_method, options)
    end

    def build_settings
      root_settings = Settings.new
      registered_sources.each do |source|
        current_namespace_settings = root_settings
        source_settings = source.load_settings!
        namespaces = Array(source.namespace)
        namespaces.each do |namespace_key|
          current_namespace_settings[namespace_key] ||= Settings.new
          current_namespace_settings = current_namespace_settings[namespace_key]
        end
        current_namespace_settings.merge!(source_settings)
      end
      root_settings
    end

    private

    def add_cli_flags_source(options = {})
      @sources << Sources::CliFlags.new(options)
    end

    def add_env_source(options = {})
      @sources << Sources::Env.new(options)
    end

    def add_yaml_source(options = {})
      @sources << Sources::Yaml.new(options)
    end
  end
end