require "yaml"

module Onefig
  module Sources
    class Yaml < AbstractSource
      attr_reader :path

      def initialize(options = {})
        @path = options[:path].to_s
        super(options)
      end

      private

      def load_data_from_file
        data = {}
        if @path && File.exist?(@path)
          data = YAML.load_file(@path)
        end
        data
      end

      def data_from_source
        load_data_from_file
      end
    end
  end
end