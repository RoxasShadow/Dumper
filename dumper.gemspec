Kernel.load 'lib/dumper/version.rb'

Gem::Specification.new { |s|
  s.name          = 'image-dumper'
  s.version       = Dumper::version
  s.author        = 'Giovanni Capuano'
  s.email         = 'webmaster@giovannicapuano.net'
  s.homepage      = 'https://github.com/RoxasShadow'
  s.summary       = 'Fetch and download image gallery.'
  s.description   = 'A dumper to download whole galleries from board like 4chan, imagebam, mangaeden, deviantart, etc.'
  s.licenses      = 'GPL-3'

  s.require_paths = ['lib']
  s.files         = Dir.glob('lib/**/*.rb')
  s.executables   = 'dumper'
  s.test_files    = Dir.glob('spec/**/*_spec.rb')

  s.add_dependency 'nokogiri'
  s.add_dependency 'certified'
  s.add_dependency 'addressable'
  s.add_dependency 'json'
  s.add_dependency 'thread'
  s.add_dependency 'alakazam'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fastimage'
  s.add_development_dependency 'parallel_tests'
}