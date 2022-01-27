lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nxt_error_registry/version"

Gem::Specification.new do |spec|
  spec.name          = "nxt_error_registry"
  spec.version       = NxtErrorRegistry::VERSION
  spec.authors       = ["Andreas Robecke", "Nils Sommer", "Raphael Kallensee", "Akihiko Ito"]
  spec.email         = ["a.robecke@getsafe.de"]

  spec.summary       = %q{Registry to register errors with unique codes and more.}
  spec.homepage      = "https://github.com/nxt-insurance"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/nxt-insurance/nxt_error_registry"
    spec.metadata["changelog_uri"] = "https://github.com/nxt-insurance/nxt_error_registry/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.5.1"
  spec.add_development_dependency "pry"
  spec.add_dependency 'activesupport', '< 8.0'
  spec.add_dependency "railties", "< 8.0"
end
