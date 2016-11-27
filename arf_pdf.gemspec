# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arf_pdf/version'

Gem::Specification.new do |spec|
  spec.name          = "arf_pdf"
  spec.version       = ArfPdf::VERSION
  spec.authors       = ["Ondřej Pražák"]
  spec.email         = ["oprazak@redhat.com"]
  spec.description   = %q{todo}
  spec.summary       = %q{todo}
  spec.homepage      = ""
  spec.license       = "GPL-3.0"

  spec.executables   << 'arf_pdf'
  # spec.test_files = Dir["test/**/*"]
  spec.files = `git ls-files`.split("\n") - ['.gitignore']

  spec.add_dependency 'openscap', '~> 0.4.4'
  spec.add_dependency 'pdfkit', '~> 0.8.2'

  spec.add_development_dependency 'bundler'
  #spec.add_development_dependency 'rake', '10.5'
end
