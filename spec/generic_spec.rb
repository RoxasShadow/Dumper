#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_generic'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a gallery using a custom xpath' do
    url = 'http://task-force.lacumpa.biz/?p=2333'
    Dumper.get_generic url, @dir, '//div[@class="entry-content"]/p/img/@src'

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 1

    image = FastImage.size images.first
    expect(image).to         be_kind_of(Array)

    expect(image.last).to    be 800
  end
end