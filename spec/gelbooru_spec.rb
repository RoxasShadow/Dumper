#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_gelbooru'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a gallery from gelbooru' do
    url = 'http://gelbooru.com/index.php?page=post&s=list&tags=bath'
    Dumper::Profiles.get_gelbooru url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be >= 56

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be > 300
  end
end