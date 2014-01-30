#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_sankakucomplex'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps images from sankakucomplex' do
    url = 'http://www.sankakucomplex.com/2014/01/25/maken-ki-lustier-than-ever/'
    Dumper::Profiles.get_sankakucomplex url, @dir, 1, 3

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 3

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be 400
  end

  it 'dumps images from chan.sankakucomplex' do
    url = 'http://chan.sankakucomplex.com/?tags=otonashi_kotori'
    Dumper::Profiles.get_sankakucomplex url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 20

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be >= 240
  end
end