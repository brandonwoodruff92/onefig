module Onefig
  module Integrations
    module Rails
      class Railtie < ::Rails::Railtie
        def preload
          initializer_path = ::Rails.root.join("config", "initializers", "onefig.rb")
          if File.exist?(initializer_path)
            require initializer_path
          end
          Onefig.load_settings!
        end
      end
    end
  end
end