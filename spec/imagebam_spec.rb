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
    url = 'http://www.imagebam.com/gallery/sb7rsktifbm6h2lpz6einoq6mou3j57k/'
    Dumper::Profiles.get_imagebam url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 67

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be >= 600
  end
end