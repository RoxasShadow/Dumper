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

    def self.get_i_doujin(url, path, from = 1, to = 1)
      url = url.scan(/(.*?)\/p\:/).first.first if url.include? '/p:'

      pages = Nokogiri::HTML(open("#{url}/p:1")).xpath('//div[@class="pager-navigation"]').text.split(?/)[1].scan(/\d+/)[0].to_i

      1.upto(pages) { |i|
        self.get path, Nokogiri::HTML(open("#{url}/p:#{i}")).xpath('//div[@class="doujin-img-view"]/img/@src')[0]
      }
    end

    def self.info_i_doujin
      { :from => false, :to => false }
    end

  end
end