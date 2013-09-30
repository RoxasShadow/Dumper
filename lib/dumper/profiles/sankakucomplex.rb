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

    ### ALMOST BROKEN ###
    def self.get_sankakucomplex(url, path, from = 1, to = 1)
      if url.include?('idol.sankakucomplex') || url.include?('chan.sankakucomplex')
        url.gsub!('index', 'index.content')
        from.upto(to) { |page|
          u = url + "&page=#{page}"
          op = open(u)
          begin
            Nokogiri::HTML(open(u)).xpath('//a/@href').each { |p|
              p = url.gsub(/post(.+)/, p.to_s)
              begin
                Nokogiri::HTML(open(p)).xpath('//a[@id="image-link"]/img/@src').each { |q|
                  self.get path, q
                }
              rescue Exception => e
                sleep 1
                retry
              end
            }
          rescue Exception => e
            sleep 1
            retry
          end
        }
      else
        Nokogiri::HTML(open(url)).xpath('//a[@class="highslide"]/@href').each { |p|
          self.get path, p
        }
      end
    end

    def self.info_sankakucomplex
      { :from => true, :to => true }
    end

  end
end