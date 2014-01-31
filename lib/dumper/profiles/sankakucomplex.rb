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

    class SankakuComplex < Profile
      def dump(url, path, from, to)
        if url.include?('idol.sankakucomplex') || url.include?('chan.sankakucomplex')
          to     = 1 if to == -1
          prefix = url.include?('idol.sankakucomplex') ? 'idol' : 'chan'

          from.upto(to) { |page|
            u = "#{url}&page=#{page}"
            begin
              op = open u
            rescue Exception => e
              sleep 1
              retry
            end

            Nokogiri::HTML(op).xpath('//a/@href').each { |p|
              next unless p.to_s.start_with? '/post/show'
              errors = 0

              @pool.process {
                begin
                  img = Nokogiri::HTML(open("http://#{prefix}.sankakucomplex.com/#{p}")).at_xpath('//a[@itemprop="contentUrl"]/@href').to_s
                  Dumper.get path, img, { referer: u }
                rescue Exception => e
                  if errors <= 3
                    sleep 3
                    errors += 1
                    retry
                  end
                end
              }
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
            @pool.process {
              Dumper.get path, p, { referer: url }
            }
          }
        end
      end
    end

    class << self
      def get_sankakucomplex(url, path, from = 1, to = -1)
        SankakuComplex.new { |p|
          p.dump     url, path, from, to
          p.shutdown
        }
      end

      def info_sankakucomplex
        { from: :enabled, to: :enabled, type: :images }
      end
    end

  end
end