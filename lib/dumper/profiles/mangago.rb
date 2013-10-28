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

    def self.get_mangago(url, path, from = 1, to = 1)
      n_pages = to > 1 ? to : Nokogiri::HTML(open(url)).at_xpath('//div[@class="page_select right"]/div[2]').text.scan(/\d+/).last.to_i

      from.upto(n_pages) { |i|
        page = Nokogiri::HTML(open(url))

        url  = page.at_xpath('//a[@id="pic_container"]/@href').to_s
        scan = page.at_xpath('//img[@id="page1"]/@src').to_s[0..-3]

        self.get path, scan, 'mozilla', url, "#{i}.#{scan.split(?.).last}"
      }
    end

    def self.info_mangago
      { :from => true, :to => true }
    end

  end
end