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

    class Behoimi < Profile
      def dump(url, path, from, to)
        from.upto(to) { |i|
          Nokogiri::HTML(open("#{url}&page=#{i}", 'User-Agent' => Dumper::USER_AGENT, 'Referer' => url)).xpath('//img[@class="preview    "]/@src').each { |p|
            @pool.process {
              Dumper.get path, p.to_s.gsub('preview/', ''), { referer: url }
            }
          }
        }
      end
    end

    class << self
      def get_behoimi(url, path, from = 1, to = 1)
        Behoimi.new { |p|
          p.dump     url, path, from, to
          p.shutdown
        }
      end

      def info_behoimi
        { from: :enabled, to: :enabled, type: :images }
      end
    end

  end
end
