# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "metalive/version"

Gem::Specification.new do |s|
  s.name        = "metalive"
  s.version     = Metalive::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alban Peignier", "Florent Peyraud"]
  s.email       = ["alban@tryphon.eu", "florent@tryphon.eu"]
  s.homepage    = "http://projects.tryphon.eu/metalive"
  s.summary     = %q{Manage live broadcast metadata}
  s.description = %q{Transport, transform and distribute metadata of broadcasted contents (title, artist, url, ...)}

  s.rubyforge_project = "metalive"

  s.add_dependency "httparty"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
