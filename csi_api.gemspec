# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "csi_api/version"

Gem::Specification.new do |s|
  s.name        = "CsiApi"
  s.version     = CsiApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Stuart Terrett"]
  s.email       = ["sterrett@mp-sportsclub.com"]
  s.homepage    = "http://sportsclubla.com"
  s.summary     = %q{A gem that allows the CSI Spectrum NG Api to be consumed in Rails}
  s.description = %q{CsiApi provides a wrapper for CSI's SOAP Api using Savon}

  s.add_runtime_dependency "savon"
  s.add_development_dependency "savon"
  s.add_development_dependency "rspec", "~>2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end