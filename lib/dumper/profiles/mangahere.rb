#--
# Copyright(C) 2013 Giovanni Capuano <webmaster@giovannicapuano.net>
#
# This file is part of Dumper.
#
# Dumper is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Dumper is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Dumper.  If not, see <http://www.gnu.org/licenses/>.
#++

module Dumper
  module Profiles

    def self.get_mangahere(url, path, from = 1, to = 1)
      Nokogiri::HTML(open(url)).xpath('//div[@class="detail_list"]/ul/li').each { |p|
        chapter = p.children[1].children[1]['href'].to_s

        dir = File.join path, p.children[1].text.sanitize_filename
        Dir.mkdir(dir) unless File.directory? dir

        option = Nokogiri::HTML(open(chapter)).xpath('//select[@class="wid60"]/option')
        first  = option.first.text.to_i
        last   = option.last.text.to_i

        first.upto(last) { |i|
          url = chapter.gsub(/\/[0-9]+\.html/, '') + i.to_s + '.html'

          scan = Nokogiri::HTML(open(url)).xpath('//section[@id="viewer"]/a/img/@src')[0].to_s
          self.get dir, scan, '', '', "#{i}.png"
        }
      }
    end

    def self.info_mangahere
      { :from => false, :to => false }
    end

  end
end