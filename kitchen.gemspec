require_relative 'lib/kitchen/version'

Gem::Specification.new do |spec|
  spec.name          = "kitchen"
  spec.version       = Kitchen::VERSION
  spec.authors       = ["JP Slavinsky"]
  spec.email         = ["jpslav@gmail.com"]

  spec.summary       = %q{OpenStax Recipe Prototype}
  spec.description   = %q{OpenStax Recipe Prototype}
  spec.homepage      = "https://github.com/openstax/kitchen"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/openstax/kitchen"
  spec.metadata["changelog_uri"] = "https://github.com/openstax/kitchen/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'rainbow'

  spec.add_development_dependency 'byebug'
end
