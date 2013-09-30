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

    def self.get_mangaeden(url, path, from = 1, to = 1)
      Nokogiri::HTML(open(url)).xpath('//a[@class="chapterLink"]').each { |p|
        i = 1
        
        dir = File.join path, "#{p.children[1].text} - #{p.children[3].text.sanitize_filename}"
        Dir.mkdir(dir) unless File.directory? dir
        
        page = Nokogiri::HTML(open("http://www.mangaeden.com#{p['href']}"))

        page.xpath('//img[@id="mainImg"]/@src').each { |r|
          self.get dir, r, '', '', "1.png"
          i += 1
        }
        
        page.xpath('//a[@class="ui-state-default"]').each { |q|
          next unless q.text.numeric?        
          q = q['href']

          Nokogiri::HTML(open("http://www.mangaeden.com#{q}")).xpath('//img[@id="mainImg"]/@src').each { |r|
            self.get dir, r, '', '', "#{i}.png"
            i += 1
          }
        }
      }
    end

    def self.info_mangaeden
      { :from => false, :to => false }
    end

  end
end