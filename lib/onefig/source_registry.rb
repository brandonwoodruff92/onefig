module Onefig
  class SourceRegistry
    def initialize
      @sources = []
    end

    def registered_sources
      @sources
    end

    def add_source(source_type, options = {})
      source_method = "#{source_type}_source".to_sym
      raise "Unknown source type: #{source_type}" unless respond_to?(source_method)
      source = send(source_method, options)
      prepend_source = options.delete(:prepend)
      prepend_source == true ? prepend_source(source) : append_source(source)
      source
    end

    private

    def append_source(source)
      @sources << source
    end

    def prepend_source(source)
      @sources.unshift(source)
    end

    def env_source(options = {})
      Sources::Env.new(options)
    end

    def yaml_source(options = {})
      Sources::Yaml.new(options)
    end

    def cli_flags_source(options = {})
      Sources::CliFlags.new(options)
    end
  end
end