# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "admiral-meteor"
  spec.version       = '0.0.1'
  spec.authors       = ["Peter T. Brown"]
  spec.email         = ["peter@flippyhead.com"]
  spec.description   = %q{admiral thing}
  spec.summary       = %q{admiral thing}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency 'aws-sdk', '< 2'
  spec.add_dependency 'git', '~> 1.2'
  spec.add_dependency 'json', '~> 1.8'

end
