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

    class MangaHere < Profile
      def dump(url, path, from, to)
        from -=  1
        to   -=  1 if to >= -1

        [].tap { |urls|
          Nokogiri::HTML(open(url)).xpath('//div[@class="detail_list"]/ul/li').each { |u|
            urls << u unless u.at_xpath('.//span/a/@href').to_s.strip.empty?
          }
        }.reverse[from..to].each { |p|
          chapter = p.at_xpath('.//span/a/@href').to_s
          name    = p.at_xpath('.//span/a/text()').to_s.strip

          dir = File.join path, name.sanitize_filename
          Dir.mkdir(dir) unless File.directory? dir

          option = Nokogiri::HTML(open(chapter)).xpath '//select[@class="wid60"]/option'
          first  = option.first.text.to_i
          last   = option.last.text.to_i

          first.upto(last) { |i|
            @pool.process {
              url = chapter.gsub(/\/[0-9]+\.html/, '') + i.to_s + '.html'

              scan = Nokogiri::HTML(open(url)).xpath('//section[@id="viewer"]/a/img/@src')[0].to_s
              Dumper::Profiles.get dir, scan, '', '', "#{i}.png"
            }
          }
        }
      end
    end

    def self.get_mangahere(url, path, from = 1, to = -1)
      MangaHere.new { |p|
        p.dump     url, path, from, to
        p.shutdown
      }
    end

    def self.info_mangahere
      { from: :enabled, to: :enabled, type: :chapters }
    end

  end
end