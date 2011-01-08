# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "logstats/version"

Gem::Specification.new do |s|
  s.name        = "logstats"
  s.version     = Logstats::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Stirk"]
  s.email       = ["jstirk@oobleyboo.com"]
  s.homepage    = "http://github.com/jstirk/logstats"
  s.summary     = "Generates a simple HTML file based upon my custom timesheet format."
  s.description = "Generates a simple HTML file based upon my custom timesheet format."

  s.rubyforge_project = "logstats"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('tail_from_sentinel', '>= 0.0.1')
  s.add_dependency('haml', '~> 3.0.25')
end
