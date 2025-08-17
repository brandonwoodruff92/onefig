module Onefig
  module Configuration
    class Yaml
      include Configurable

      config(:paths) { [] }
    end
  end
end