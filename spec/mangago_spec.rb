#! /usr/bin/env ruby
require 'dumper'
require 'fastimage'
require 'fileutils'

describe 'Dumper' do
  before do
    @dir = 'tmp_mangago'
    Dir.mkdir @dir
  end

  after do
    FileUtils.rm_r @dir
  end

  it 'dumps a manga from mangago' do
    url = 'http://www.mangago.com/read-manga/ore_no_imouto_ga_konna_ni_kawaii_wake_ga_nai_my_angel_ayase_is_so_cute_doujinshi/bt/71284/Ch1/'
    Dumper::Profiles.get_mangago url, @dir

    images = Dir["#{@dir}/*"]
    expect(images.length).to be 21

    image = FastImage.size images.last
    expect(image).to         be_kind_of(Array)

    expect(image.last).to    be 1300
  end
end