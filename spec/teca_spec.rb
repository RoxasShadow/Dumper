#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_teca'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a page from teca' do
    url = 'http://alfateam123.niggazwithattitu.de/screens/anime_screens/sakura%20trick/index.html'
    Dumper::Profiles.get_teca url, @dir, 1, 4

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 4

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be 1280
  end
end