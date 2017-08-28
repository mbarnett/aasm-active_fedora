# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aasm-active_fedora/version'

Gem::Specification.new do |spec|
  spec.name          = 'aasm-active_fedora'
  spec.version       = Aasm::ActiveFedora::VERSION
  spec.authors       = ['Matt Barnett']
  spec.email         = ['matt@sixtyodd.com']

  spec.summary       = %q{ActiveFedora persistence adaptor for AASM}
  spec.homepage      = 'https://github.com/ualbertalib/aasm-active_fedora'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = 'TODO: Set to http://mygemserver.com'
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  # end

  spec.files         = `git ls-files`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'aasm', '~> 4.11'
  spec.add_dependency 'active-fedora'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
