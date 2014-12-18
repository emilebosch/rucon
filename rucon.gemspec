require './lib/rucon/version'

Gem::Specification.new do |s|
  s.name        = 'rucon'
  s.version     = Rucon::VERSION
  s.date        = '2014-12-18'
  s.summary     = "Rucon"
  s.description = "Ruby mini container"
  s.authors     = ["Emile Bosch"]
  s.email       = 'emilebosch@me.com'
  s.files        = Dir.glob('{lib}/**/*') + %w(README.md rucon.gemspec Gemfile)
  s.homepage    = 'https://github.com/emilebosch/rucon'
  s.license     = 'MIT'
  s.executables << 'rucon'

  s.add_dependency 'thor'
  s.add_dependency 'bundler'
  s.add_dependency 'hashdiff'

  s.add_development_dependency 'rake'
end