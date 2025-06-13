$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cadi_menu/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "cadi_menu"
  spec.version     = CadiMenu::VERSION
  spec.authors     = ["Daniel2193"]
  spec.email       = ["ds@ww.digital"]
  spec.homepage    = "https://github.com/wirtschaftswunder-digital"
  spec.summary     = "Summary of CadiMenu."
  spec.description = "Description of CadiMenu."
  spec.license     = ""

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  spec.add_dependency "httparty"
end
