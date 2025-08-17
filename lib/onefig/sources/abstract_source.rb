module Onefig
  module Sources
    class AbstractSource
      attr_reader :namespace, :settings

      def initialize(options = {})
        @namespace = options[:namespace]
        @loaded = false
      end

      def load_settings!
        source_settings = build_settings
        raise "build_settings must return a Settings object or hash" unless source_settings.is_a?(Settings) || source_settings.is_a?(Hash)
        @settings = source_settings.is_a?(Settings) ? source_settings : Settings.new(source_settings)
        @loaded = true
        @settings
      end

      def unload_settings!
        @settings = nil
        @loaded = false
      end

      def reload_settings!
        unload_settings!
        load_settings!
      end

      def loaded?
        @loaded
      end

      private

      def build_settings
        raise NotImplementedError, "Subclass must implement #build_settings"
      end
    end
  end
end