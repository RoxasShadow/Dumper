#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_behoimi'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a thread from behoimi' do
    url = 'http://behoimi.org/post/index?tags=kaeru'
    Dumper::Profiles.get_behoimi url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 16

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be 800
  end
end