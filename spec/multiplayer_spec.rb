#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_multiplayer'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a page from multiplayer' do
    url = 'http://multiplayer.it/giochi/the-witcher-3-wild-hunt-per-pc.html'
    Dumper::Profiles.get_multiplayer url, @dir, 60, 66

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 7

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be >= 300
  end
end