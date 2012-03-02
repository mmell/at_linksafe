$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "at_linksafe/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "at_linksafe"
  s.version     = AtLinksafe::VERSION
  s.authors     = ["Mike Mell"]
  s.email       = ["mike@linksafe.name"]
  s.homepage    = ""
  s.summary     = %q{A collection of iname-related utilities alongside a collection of Rails extras.}
  s.description = s.summary

  s.require_paths = ["lib"]

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.1.1"

end
