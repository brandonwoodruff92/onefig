module Onefig
  class SourceRegistry
    def initialize
      @sources = []
    end

    def registered_sources
      @sources
    end

    def add_source(source_type, options = {})
      source = Sources.build_source(source_type, options)
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
  end
end