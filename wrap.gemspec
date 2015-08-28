# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require File.expand_path("../lib/wrap/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'wrap'
  spec.version       = Wrap::VERSION
  spec.authors       = ['gabz75']
  spec.email         = ['gabriel.debeaupuis@gmail.com']
  spec.description   = 'HTTP Rails Restful client'
  spec.summary       = 'HTTP Rails Restful client'
  spec.homepage      = 'https://github.com/gabz75/wrap'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client'
end
