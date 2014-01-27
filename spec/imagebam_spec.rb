#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_imagebam'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a gallery from imagebam' do
    url = 'http://www.imagebam.com/gallery/ab4f428e9eec0c70bc53b27cfb91d902/'
    Dumper::Profiles.get_imagebam url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be >= 94

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be 511
  end
end