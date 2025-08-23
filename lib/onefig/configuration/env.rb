module Onefig
  module Configuration
    class Env
      include Configurable

      config(:split_prefixes) { false }
      
      config(:case_sensitive_matching) { false }
    end
  end
end