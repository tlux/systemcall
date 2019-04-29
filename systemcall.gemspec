# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'system_call/version'

Gem::Specification.new do |spec|
  spec.name = 'systemcall'
  spec.version = SystemCall::VERSION
  spec.authors = ['Tobias Casper']
  spec.email = ['tobias.casper@gmail.com']

  spec.summary = 'A simple wrapper to run CLI programs.'
  spec.description = "A simple wrapper around Ruby's Open3 to call CLI " \
    'programs and process their output.'
  spec.homepage = 'https://github.com/tlux/systemcall'
  spec.license = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.68.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.1.0'
  spec.add_development_dependency 'yard', '~> 0.9.19'
end
