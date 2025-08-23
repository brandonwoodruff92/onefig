module Onefig
  module Sources
    class_methods do
      def build_source(source_type, options = {})
        const_get(source_type.to_s.capitalize).new(options)
      end
    end
  end
end