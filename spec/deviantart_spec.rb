#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_deviantart'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a gallery from deviantart' do
    url = 'http://targete.deviantart.com/gallery/?offset=72'
    Dumper::Profiles.get_deviantart url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be >= 20

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be > 300
  end
end