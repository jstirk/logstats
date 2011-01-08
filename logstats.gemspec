Gem::Specification.new do |s|
  s.name = %q{logstats}
  s.version = "0.0.1"
  s.date = %q{2011-01-08}
  s.authors = ["Jason Stirk"]
  s.email = %q{jstirk@oobleyboo.com}
  s.summary = %q{LogStats generates a simple HTML file based upon my custom timesheet format.}
  s.homepage = %q{http://github.com/jstirk/logstats}
  s.description = %q{LogStats generates a simple HTML file based upon my custom timesheet format.}
  s.files = [ "README", "lib/parseconfig.rb"]
  s.add_dependency('tail_from_sentinel', '>= 0.0.1')
  s.add_dependency('haml', '~> 3.0.25')
end
