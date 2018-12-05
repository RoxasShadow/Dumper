#--
# Copyright(C) 2015 Giovanni Capuano <webmaster@giovannicapuano.net>
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

    class YandeRe < Profile
      def dump(url, path, from, to)
        from.upto(to) { |i|
          notify_observers status: "--- Page #{i} ---"

          Nokogiri::HTML(open("#{url}&page=#{i}", 'User-Agent' => Dumper::USER_AGENT, 'Referer' => url)).xpath('//a[@class="thumb"]/@href').each { |p|
            @pool.process {
              img = Nokogiri::HTML(open('https://' + URI.parse(url).hostname + p,
                'User-Agent' => Dumper::USER_AGENT,
                'Referer'    => url
              )).at_xpath('//a[@id="png" or @id="highres"]/@href').text
              Dumper.get path, img, { referer: url }
            }
          }
        }
      end
    end

    class << self
      def get_yande(url, path, from = 1, to = 1)
        YandeRe.new { |p|
          p.dump     url, path, from, to
          p.shutdown
        }
      end

      def info_yande
        { from: :enabled, to: :enabled, type: :pages }
      end
    end

  end
end
