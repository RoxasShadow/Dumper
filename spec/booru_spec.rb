#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_booru'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a page from *booru' do
    url = 'http://safebooru.org/index.php?page=post&s=list&tags=crying'
    Dumper::Profiles.get_booru url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be >= 27

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be >= 300
  end
end