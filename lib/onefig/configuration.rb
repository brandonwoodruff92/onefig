module Onefig
  class Configuration
    include Configurable

    config(:sources) { Configuration::Sources.instance }

    config(:const_name) { "Config" }
  end
end

