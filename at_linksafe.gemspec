# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "at_linksafe/version"

Gem::Specification.new do |s|
  s.name        = "at_linksafe"
  s.version     = AtLinksafe::VERSION
  s.authors     = ["Mike Mell"]
  s.email       = ["mike@linksafe.name"]
  s.homepage    = ""
  s.summary     = %q{A collection of iname-related utilities alongside a collection of Rails extras.}
  s.description = s.summary

  s.rubyforge_project = "at_linksafe"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
