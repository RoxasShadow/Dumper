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

    class Multiplayer < Profile
      def dump(url, path, from, to)
        from -= 1
        to   -= 1 if to >= 1

        url.gsub! /\/giochi\//, '/immagini/galleria/'
        url.gsub! '.html', ''
        gallery = JSON.parse open("#{url}?from=#{from}").read

        to -= from if to >= 1
        gallery['objects'].reverse[0..to].each { |image|
          @pool.process {
            Dumper::Profiles.get path, image['image']
          }
        }
      end
    end

    def self.get_multiplayer(url, path, from = 1, to = -1)
      Multiplayer.new { |p|
        p.dump     url, path, from, to
        p.shutdown
      }
    end

    def self.info_multiplayer
      { from: :enabled, to: :enabled, type: :images }
    end

  end
end