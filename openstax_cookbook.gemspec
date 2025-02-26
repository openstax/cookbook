# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'openstax_cookbook'
  spec.version       = '1.0.0'
  spec.authors       = ['JP Slavinsky']
  spec.email         = ['jpslav@gmail.com']

  spec.summary       = 'OpenStax content baking package'
  spec.description   = 'OpenStax content baking package'
  spec.homepage      = 'https://github.com/openstax/cookbook'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.2.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/openstax/cookbook'
  spec.metadata['changelog_uri'] = 'https://github.com/openstax/cookbook/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(/^(test|spec|features)\//) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(/^exe\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'i18n'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'rainbow'
  spec.add_dependency 'twitter_cldr'
  spec.add_dependency 'sorted_set'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'inch'
  spec.add_development_dependency 'nokogiri-diff'
  spec.add_development_dependency 'rainbow'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'yard'
end
