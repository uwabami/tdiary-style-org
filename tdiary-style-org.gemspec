# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tdiary/style/org/version'

Gem::Specification.new do |spec|
  spec.name          = 'tdiary-style-org'
  spec.version       = TDiary::Style::Org::VERSION
  spec.authors       = ['Youhei SASAKI']
  spec.email         = ['uwabami@gfd-dennou.org']
  spec.description   = %q{Org-mode style for tDiary, using org-ruby}
  spec.summary       = %q{Org-mode style for tDiary, using org-ruby}
  spec.homepage      = 'https://github.com/uwabami/tdiary-style-org'
  spec.license       = 'MIT'

  spec.files         = [".gitignore",".rspec",".travis.yml","Gemfile","LICENSE","README.org","Rakefile","lib/tdiary-style-org.rb","lib/tdiary/style/org.rb","lib/tdiary/style/org/html_tags.yml","lib/tdiary/style/org/version.rb","tdiary-style-org.gemspec","spec/spec_helper.rb", "spec/tdiary/style/org_spec.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'org-ruby'
  spec.add_dependency 'pygments.rb'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
