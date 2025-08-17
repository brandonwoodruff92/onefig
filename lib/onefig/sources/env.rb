module Onefig
  module Sources
    class Env < AbstractSource
      attr_reader :env

      def initialize(env)  
        @env = env
      end

      def fetch(key)
        if Onefig.config.sources.env.case_sensitive_matching
          env[key]
        else
          result = env.values_at(key, key.upcase, key.downcase, key.downcase.capitalize)
          result.compact.first
        end
      end
    end
  end
end