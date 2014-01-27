#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_yande'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a page from yandere' do
    url = 'https://yande.re/post?tags=aragaki_ayase'
    Dumper::Profiles.get_yande url, @dir, 2, 2

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 16

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be > 300
  end
end