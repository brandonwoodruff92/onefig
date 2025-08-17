module Onefig
  module Configuration
    class Env
      include Configurable

      config(:case_sensitive_matching) { true }
    end
  end
end