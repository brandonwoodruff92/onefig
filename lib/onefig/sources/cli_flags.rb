module Onefig
  module Sources
    class CliFlags < AbstractSource
      def initialize(options = {})
        @parse_cli_values = options[:parse_cli_values] || true
        super(options)
      end

      def parse_cli_values?
        @parse_cli_values
      end

      private

      def data_from_source
        extract_cli_flags
      end

      def extract_cli_flags
        flags = {}
        set_flag = -> (key, value) do
          value = parse_cli_values? ? parse_value(value) : value
          flags[key.to_sym] = value
        end
        ARGV.each_with_index do |arg, index|
          case arg
          when /^--([^=]+)=(.*)$/
            set_flag.call($1.to_sym, $2)
          when /^--(.+)$/
            next_arg = ARGV[index + 1]
            if next_arg && !next_arg.start_with?('-')
              set_flag.call($1.to_sym, next_arg)
            else
              set_flag.call($1.to_sym, true)
            end
          when /^-([a-zA-Z])(.+)$/
            set_flag.call($1.to_sym, $2)
          when /^-([a-zA-Z])$/
            next_arg = ARGV[index + 1]
            if next_arg && !next_arg.start_with?('-')
              set_flag.call($1.to_sym, next_arg)
            else
              set_flag.call($1.to_sym, true)
            end
          end
        end
        
        flags
      end

      def parse_value(value)
        return value unless value.is_a?(String)
        case value
        when /^true$/i
          true
        when /^false$/i
          false
        when /^\d+$/
          value.to_i
        when /^\d+\.\d+$/
          value.to_f
        else
          value
        end
      end
    end
  end
end