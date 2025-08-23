module Onefig
  module Sources
    class AbstractSource
      attr_reader :namespace, :settings

      def initialize(options = {})
        @namespace = options[:namespace]
        @loaded = false
      end

      def load_settings!
        source_data = data_from_source
        unless source_data.is_a?(Settings) || source_data.is_a?(Hash)
          raise "data_from_source must return a Settings object or hash"
        end
        @settings = source_data.is_a?(Settings) ? source_data : Settings.new(source_data)
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

      def data_from_source
        raise NotImplementedError, "Subclass must implement #data_from_source"
      end
    end
  end
end