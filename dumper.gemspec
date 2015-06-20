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

  s.add_dependency 'nokogiri',    '~> 1.6'
  s.add_dependency 'certified',   '~> 1.0'
  s.add_dependency 'addressable', '~> 2.3'
  s.add_dependency 'iconv',       '~> 1.0'
  s.add_dependency 'json',        '~> 1.8'
  s.add_dependency 'thread',      '~> 0.1'
  s.add_dependency 'rainbow',     '~> 1.1',  '1.1.4'
  s.add_dependency 'thor',        '~> 0.19', '0.19.1'
  s.add_dependency 'alakazam',    '~> 0.4'

  s.add_development_dependency 'rake',           '~> 10.3'
  s.add_development_dependency 'rspec',          '~> 3.1'
  s.add_development_dependency 'fastimage',      '~> 1.6'
  s.add_development_dependency 'parallel_tests', '~> 1.0'
}
