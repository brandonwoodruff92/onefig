module Onefig
  module Configurable
    included do
      include Singleton
    end
    
    class_methods do
      def config(name)
        instance_variable = "@#{name}".to_sym
        define_method(name) do
          value = instance_variable_get(instance_variable)
          if value.nil?
            value = yield if block_given?
            instance_variable_set(instance_variable, value) if value
          end
          value
        end
        define_method("#{name}=") do |value|
          instance_variable_set(instance_variable, value)
        end
      end
    end
  end
end