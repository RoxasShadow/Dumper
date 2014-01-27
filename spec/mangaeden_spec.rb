#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_mangaeden'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a manga from mangaeden' do
    url = 'http://www.mangaeden.com/en-manga/nisekoi'
    Dumper::Profiles.get_mangaeden url, @dir, 1, 2

    images = Dir["#{@dir}/*_Question/*"]
    expect(images.length).to be 5

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be 889
  end
end