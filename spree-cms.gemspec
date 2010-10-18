Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = %q{spree-cms}
  s.version     = '0.0.1'
  s.summary     = 'Spree Extension that adds CMS capabilities to the core platform'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  # s.author            = 'David Heinemeier Hansson'
  # s.email             = 'david@loudthinking.com'
  # s.homepage          = 'http://www.rubyonrails.org'
  # s.rubyforge_project = 'actionmailer'

  s.files        = Dir['CHANGELOG', 'README.markdown', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('is_taggable')
  s.add_dependency('RedCloth')
  s.add_dependency('disqus')
  s.add_dependency('spree_core', '>= 0.30.0.beta1')
end
