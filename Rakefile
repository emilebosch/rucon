require 'rake/testtask'
require './lib/rucon/version'

task :uninstall do
  puts 'Unintalling..'
  `gem uninstall rucon -ax`
  `rbenv rehash`
end

task :install => :uninstall  do
  `rm *.gem`
  `gem build rucon.gemspec`
  `gem install --local rucon-#{rucon::VERSION}.gem`
  `rbenv rehash`
end