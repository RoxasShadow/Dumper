#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_redblow'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a page from redblow' do
    url = 'http://www.redblow.com/asuka-kirara-in-black-dress/'
    Dumper::Profiles.get_redblow url, @dir, 1, 3

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 3

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.first).to   be 800
  end
end