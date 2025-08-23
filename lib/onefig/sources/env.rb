module Onefig
  module Sources
    class Env < AbstractSource
      attr_reader :env, :prefix, :split_prefixes, :case_sensitive_matching

      def initialize(options)
        @env = options[:env] || ENV
        @prefix = options[:prefix]
        @split_prefixes = options[:split_prefixes] || false
        @case_sensitive_matching = options[:case_sensitive_matching] || false
        super(namespace: prefixes) if !options[:namespace]
      end

      private

      def data_from_source
        return {} if @env.present?
        result = {}
        @env.each do |key, value|
          next if prefix && !key_matches_prefix?(key)
          key = key.downcase if !case_sensitive_matching
          result[key] = value
        end
        result
      end

      def prefixes
        return @prefixes if @prefixes
        separators = /[\-\/_]/
        if prefix.include?(".")
          @prefixes = prefix.split(".")
          if split_prefixes
            @prefixes = @prefixes.flat_map { |part| part.split(separators) }
          end
        elsif split_prefixes && prefix.match?(separators)
          @prefixes = prefix.split(separators)
        else
          @prefixes = [prefix]
        end
        @prefixes.map!(&:downcase) if !config.case_sensitive_matching
        @prefixes
      end

      def key_matches_prefix?(key)
        if config.case_sensitive_matching
          key.start_with?(prefix)
        else
          key.downcase.start_with?(prefix.downcase)
        end
      end
    end
  end
end