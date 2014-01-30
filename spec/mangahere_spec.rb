#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_mangahere'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a manga from mangahere' do
    url = 'http://www.mangahere.com/manga/love_all/'
    Dumper::Profiles.get_mangahere url, @dir, 1, 2

    images = Dir["#{@dir}/*_2/*"]
    expect(images.length).to be 41

    image = FastImage.size images.first
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be 453
  end
end