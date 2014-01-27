#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_fakku'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a manga from fakku' do
    url = 'http://www.fakku.net/doujinshi/connected-feelings-english'
    Dumper::Profiles.get_fakku url, @dir, 1, 5

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 5

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be > 300
  end
end