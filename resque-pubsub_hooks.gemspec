# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque/pubsub_hooks/version'

Gem::Specification.new do |spec|
  spec.name          = "resque-pubsub_hooks"
  spec.version       = Resque::Plugins::PubsubHooks::VERSION
  spec.authors       = ["Brandon Tilley"]
  spec.email         = ["brandon@brandontilley.com"]
  spec.description   = %q{Add Redis pub/sub hooks to your Resque jobs and workers}
  spec.summary       = %q{Add Redis pub/sub hooks to your Resque jobs and workers}
  spec.homepage      = "https://github.com/BinaryMuse/resque-pubsub_hooks"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redis"

  spec.add_development_dependency "resque", "~> 1.24"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
