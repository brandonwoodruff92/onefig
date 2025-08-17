module Onefig
  module Configuration
    class CliFlags
      include Configurable

      config(:parse_cli_values) { true }
    end
  end
end