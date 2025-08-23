# Onefig

Onefig consolidates all of your configuration sources into a single source of truth, making it incredibly easy for your application to get the settings it needs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "onefig"
```

and then execute:
```bash
$ bundle install
```

or install it yourself as:
```bash
$ gem install onefig
```

## Configuration
Register your configurations sources:
```ruby
Onefig.configure do |config|
  config.sources.register_sources do 
    # Loads all ARGV cli flags
    add_source(:cli_flags)
    # Loads all ENV variables with "APP_CONFIG" prefix
    add_source(:env, prefix: "APP_CONFIG")
    # Loads all configurations from "config/settings.yaml"
    add_source(:yaml, path: "config/settings.yaml")
  end
end
```
By default, `env` sources are namespaced under the prefix provided, while all other sources are namespaced under root. When duplicate configuration keys are present among multiple sources (i.e `cli_flags` and `config/settings.yaml` both define `APP_ENV`), the source that was registered first will override the value of later sources. If you don't want this to happen, you can namespace sources:
```ruby
Onefig.configure do |config|
  config.sources.register_sources do
    # Accessed at the `root` namespace: Config
    add_source(:cli_flags)
    # Accessed at the `app_config` namespace: Config.app_config
    add_source(:env, prefix: "APP_CONFIG")
    # Accessed at the 'database.mysql` namespace: Config.database.mysql
    add_source(:env, prefix: "MYSQL", namespace: %i[ database mysql ])
    # Accessed at the 'database.pg` namespace: Config.database.pg
    add_source(:env, prefix: "POSTGRES", namespace: %i[ database pg ])
    # Accessed at the `settings` namespace: Config.settings
    add_source(:yaml, path: "config/settings.yaml", namespace: :settings)
  end
end
```
For `env` sources, you can also specify the `split_prefixes` option to split the prefix into multiple namespaces:
```ruby
Onefig.configure do |config|
  config.sources.register_sources do 
    # Accessed at the "app.config" namespace: Config.app.config
    add_source(:env, prefix: "APP_CONFIG", split_prefixes: true)
    # Accessed at the "some.prefix" namespace: Config.some.prefix
    add_source(:env, prefix: "some-prefix", split_prefixes: true)
    # Accessed at the "some.really.weird.prefix" namespace: Config.some.really.weird.prefix
    add_source(:env, prefix: "some_really-weird.prefix", split_prefixes: true)
  end
end

# or set the global default setting to true

Onefig.configure do |config|
  config.sources.env.split_prefixes = true
end
```
NOTE: Prefixes with a `.` separator will automatically be split regardless of the `split_prefixes` option:
```ruby
Onefig.configure do |config|
  config.sources.register_sources do 
    # Accessed at the "rack.session" namespace: Config.rack.session
    add_source(:env, prefix: "rack.session") 
  end
end
```

