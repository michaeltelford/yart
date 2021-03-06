# frozen_string_literal: true

require_relative "lib/yart/version"

Gem::Specification.new do |spec|
  spec.name          = "yart"
  spec.version       = YART::VERSION
  spec.authors       = ["Michael Telford"]
  spec.email         = ["michael.telford@live.com"]

  spec.summary       = "Yet Another Ruby Templater (YART) turns plain Ruby into HTML making it fun to write webpages."
  spec.description   = <<~TEXT
    Yet Another Ruby Templater (YART) turns plain Ruby into HTML making it fun to write webpages.

    - YART provides an intuitive DSL that feels natural to use and removes the boiler plate from writing HTML
    - YART has zero runtime dependencies and ~120 LOC
    - YART is fully unit tested
  TEXT
  spec.homepage      = "https://github.com/michaeltelford/yart"
  spec.license       = "MIT"

  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = "~> 2.7"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
