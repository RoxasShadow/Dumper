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

    class Booru < Profile
      def dump(url, path, from, to)
        page = 0
        
        from.upto(to) { |i|
          notify_observers status: "--- Page #{i} ---"

          Nokogiri::HTML(open("#{url}&pid=#{page}")).xpath('//span[@class="thumb"]').each { |u|
            @pool.process {
              Dumper.get path, u.child.child['src'].gsub(/thumbs/, 'img').gsub(/thumbnails\//, 'images/').gsub(/thumbnail_/, '')
            }
          }
          
          page += 40
        }
      end
    end

    class << self
      def get_booru(url, path, from = 1, to = 1)
        Booru.new { |p|
          p.dump     url, path, from, to
          p.shutdown
        }
      end

      def info_booru
        { from: :enabled, to: :enabled, type: :pages }
      end
    end

  end
end