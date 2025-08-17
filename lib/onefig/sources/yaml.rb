require "yaml"

module Onefig
  module Sources
    class Yaml < AbstractSource
      attr_reader :path

      def initialize(path)
        @path = path.to_s
        @loaded = false
      end

      def fetch(key)
        data[key]
      end

      def loaded?
        @loaded
      end

      def load!
        if @path && File.exist?(@path)
          @data = YAML.load_file(@path) || {}
        else
          raise "Could not load file: #{@path}"
        end
        @loaded = true
      end

      def unload!
        @loaded = false
        @data = nil
      end

      def reload!
        unload!
        load!
      end

      def data
        load! unless loaded?
        @data
      end
    end
  end
end