module Onefig
  module Configuration
    class Sources
      include Configurable

      config(:cli_flags) { CliFlags.instance }

      config(:env) { Env.instance }

      config(:yaml) { Yaml.instance }

      def register_sources(&block)
        @source_registry ||= SourceRegistry.new
        @source_registry.instance_eval(&block)
      end

      def source_registry
        @source_registry
      end

      def registered_sources
        @source_registry.registered_sources
      end
    end
  end
end