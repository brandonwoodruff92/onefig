module Onefig
  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Configuration.instance
    end

    def load_settings!
      settings = build_settings_from_registry
      const_name = config.const_name.classify
      Object.const_set(const_name, settings)
    end

    def registered_sources
      config.sources.source_registry.registered_sources
    end

    private

    def build_settings_from_registry
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
  end
end

# Onefig.configure do |config|
#   config.sources.register_sources do
#     add_source(:env, prefix: "ONEFIG", prepend: true)
#     add_source(:env, prefix: "PG", namespace: :postgres)
#     add_source(:env, prefix: "MYSQL", namespace: [:mysql, :production])
#     add_source(:yaml, path: "config/onefig.yml")
#     add_directory_source(:yaml, dir: "config/settings", directory_namespacing: true)
#     add_source(:cli_flags)
#   end
# end
