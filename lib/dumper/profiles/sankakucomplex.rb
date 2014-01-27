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

    def self.get_sankakucomplex(url, path, from = 1, to = -1)
      ua = 'Mozilla/5.0 (Windows NT 6.2; WOW64; rv:16.0) Gecko/20100101 Firefox/16.0'

      if url.include?('idol.sankakucomplex') || url.include?('chan.sankakucomplex')
        to     = 1 if to == -1
        prefix = url.include?('idol.sankakucomplex') ? 'idol' : 'chan'

        from.upto(to) { |page|
          u  = url + "&page=#{page}"
          begin
            op = open u
          rescue Exception => e
            sleep 1
            retry
          end

          Nokogiri::HTML(op).xpath('//a/@href').each { |p|
            next unless p.to_s.start_with? '/post/show'

            Thread.new {
              begin
                img = Nokogiri::HTML(open("http://#{prefix}.sankakucomplex.com/#{p}")).at_xpath('//a[@itemprop="contentUrl"]/@href').to_s
                self.get path, img, ua, u
              rescue Exception => e
                retry
              end
            }.join
          }
        }
      else
        from -= 1
        to   -= 1 if to >= 1

        [].tap { |urls|
          Nokogiri::HTML(open(url)).xpath('//a[@target="_blank"]/@href').each { |u|
            urls << u if u.to_s.start_with? 'http://images.sankakucomplex.com/wp-content/'
          }
        }[from..to].each { |p|
          Thread.new {
            self.get path, p, ua, url
          }.join
        }
      end
    end

    def self.info_sankakucomplex
      { from: :enabled, to: :enabled, type: :images }
    end

  end
end