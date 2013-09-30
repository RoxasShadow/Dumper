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

    def self.get_mi9(url, path, from = 1, to = 1)
        url = url[0..-2] if url.end_with? ?/
        
        from.upto(to) { |page|
          u = url + ( page == 1 ? ?/ : "_#{page}/" )
          Nokogiri::HTML(open(u)).xpath('//a[@target="_blank"]/@href').each { |p|
            next unless p.to_s.start_with? 'http://mi9.com/wallpaper/'
            Nokogiri::HTML(open(p.to_s)).xpath('//div[@class="s_infox down"]/span/a/@href').each { |q|
              Nokogiri::HTML(open(q.to_s)).xpath('//div[@class="dimg"]/a/img/@src').each { |r|
                self.get path, r
              }
            }
          }
        }
      end

    def self.info_mi9
      { :from => true, :to => true }
    end

  end
end