# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vss/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "vss"
  s.version     = VSS::VERSION
  s.authors     = ["Mark Dodwell"]
  s.email       = ["labs@mkdynamic.co.uk"]
  s.homepage    = "https://github.com/mkdynamic/vss"
  s.summary     = "Vector Space Search"
  s.description = "A simple vector space search engine with tf*idf ranking."
  
  s.required_ruby_version = ">= 1.8.7"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_runtime_dependency "stemmer", "~> 1.0.0"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
end
