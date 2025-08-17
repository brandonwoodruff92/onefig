module Onefig
  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Configuration.instance
    end
  end
end

# Onefig.configure do |config|
#   config.sources.register_sources do
#     add_source(:env, prefix: "ONEFIG")
#     add_source(:env, prefix: "PG", namespace: :postgres)
#     add_source(:env, prefix: "MYSQL", namespace: [:mysql, :production])
#     add_source(:yaml, path: "config/onefig.yml")
#     add_directory_source(:yaml, dir: "config/settings", directory_namespacing: true)
#     add_source(:cli_flags)
#   end
# end
