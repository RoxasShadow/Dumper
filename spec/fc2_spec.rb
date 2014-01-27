#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_fc2'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a gallery from *fc2' do
    url = 'http://moeimg.blog133.fc2.com/blog-entry-5004.html'
    Dumper::Profiles.get_fc2 url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 53

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be > 300
  end
end