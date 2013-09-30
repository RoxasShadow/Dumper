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

    def self.get_wallpaperhere(url, path, from = 1, to = 1)
      start = url[/\/page\/.+?\//].delete('/page/').to_i || 1
      url   = url.sub /\/page\/.+?\//, '/page/$PAGE/'
      start.upto(to) { |page|
        u = url.gsub('$PAGE', page.to_s)
        Nokogiri::HTML(open(u)).xpath('//div[@class="wallpapers_list mt10 clearfix"]/ul[@class="clearfix"]/li').each { |p|
          p = p.xpath('a/@href').to_s
          size = Nokogiri::HTML(open('http://www.wallpaperhere.com' + p + '/download_preview')).xpath('//dl[@class="wp_rel"]/dd')[0].text
          Nokogiri::HTML(open('http://www.wallpaperhere.com' + p + '/download_' + size)).xpath('//div[@class="download_img"]/div/img/@src').each { |q|
            self.get path, 'http://www.wallpaperhere.com' + q.to_s
          }
        }
      }
    end

    def self.info_wallpaperhere
      { :from => false, :to => true }
    end

  end
end