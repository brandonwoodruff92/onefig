require_relative 'lib/onefig/version'

Gem::Specification.new do |s|
  s.name             = 'onefig'
  s.version          = Onefig::VERSION
  s.date             = Time.now.strftime '%F'
  s.authors          = ["Brandon Woodruff"]
  s.email            = %w[brandonwoodruff92@gmail.com]
  s.summary          = "A single source of truth for your application settings"
  s.description      = "An easy way to manage multi-environment settings from a single, consolidated source."
  s.homepage         = 'https://github.com/brandonwoodruff92/onefig'
  s.license          = 'MIT'

  s.files = Dir["{lib}/**/*", "README.md", "MIT-LICENSE"]

  s.required_ruby_version = '>= 2.6.0'
  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rspec', '~> 3.0'
end