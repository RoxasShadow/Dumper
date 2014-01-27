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
    url = 'http://www.deviantart.com/digitalart/paintings/illustrations/conceptual/'
    Dumper::Profiles.get_deviantart url, @dir, 1, 1

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 32

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be > 300
  end
end