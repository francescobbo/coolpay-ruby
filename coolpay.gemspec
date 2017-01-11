$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'coolpay/version'

Gem::Specification.new do |s|
  s.name         = 'coolpay'
  s.version      = Coolpay::VERSION
  s.summary      = 'Ruby bindings to Coolpay API'
  s.description  = 'Ruby bindings to Coolpay API - just for an interview'
  s.authors      = ['Francesco Boffa']
  s.email        = 'fra.boffa@gmail.com'
  s.homepage     = 'https://github.com/aomega08/coolpay'
  s.license      = 'MIT'

  s.files        = `git ls-files -- lib/*`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
end

