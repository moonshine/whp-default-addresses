Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'whp_default_addresses'
  s.version     = '1.0.1'
  s.summary     = 'Default Addresses'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 0.30.1')
end