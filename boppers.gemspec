# frozen_string_literal: true

require "./lib/boppers/version"

Gem::Specification.new do |spec|
  spec.name          = "boppers"
  spec.version       = Boppers::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["me@fnando.com"]

  spec.summary       = "A simple bot framework for individuals."
  spec.description   = spec.summary
  spec.homepage      = "https://rubygems.org/gems/boppers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "aitch"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "mail"
  spec.add_development_dependency "telegram_bot"
  spec.add_development_dependency "twitter"
end
