# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tdiary/style/org/version'

Gem::Specification.new do |spec|
  spec.name          = 'tdiary-style-org'
  spec.version       = TDiary::Style::Org::VERSION
  spec.authors       = ['Youhei SASAKI']
  spec.email         = ['uwabami@gfd-dennou.org']
  spec.description   = %q{org-mode style for tDiary, using org-ruby}
  spec.summary       = %q{org-mode style for tDiary, using org-ruby}
  spec.homepage      = 'https://github.com/uwabami/tdiary-style-org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'org-ruby'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
end
