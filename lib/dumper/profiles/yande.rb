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

    def self.get_yande(url, path, from = 1, to = 1)
      ua  = 'Mozilla/5.0 (Windows NT 6.2; WOW64; rv:16.0) Gecko/20100101 Firefox/16.0'
      ref = url

      from.upto(to) { |i|
        Nokogiri::HTML(open("#{url}&page=#{i}", 'User-Agent' => ua, 'Referer' => ref)).xpath('//a[@class="thumb"]/@href').each { |p|
          img = Nokogiri::HTML(open("https://yande.re#{p}", 'User-Agent' => ua, 'Referer' => ref)).at_xpath('//img[@id="image"]/@src').text
          self.get path, img, ua, ref
        }
        
        puts "--- Page #{i} now... ---" # there are so much pages sometimes...
        puts
      }
    end

    def self.info_yande
      { :from => true, :to => true }
    end

  end
end