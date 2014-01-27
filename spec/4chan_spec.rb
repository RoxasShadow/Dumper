#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_4chan'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a thread from 4chan' do
    url = 'https://boards.4chan.org/e/res/1436774'
    Dumper::Profiles.get_4chan url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 1

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be >= 1
  end
end