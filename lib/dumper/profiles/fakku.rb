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

    class Fakku < Profile
      def dump(url, path, from, to)
        url    += '/read' unless url.end_with? '/read'
        errors = 0

        js_thumbs_slice = open(url).read.split('window.params.thumbs')[1].split('\/thumbs\/')
        thumbs_count    = js_thumbs_slice[1..-1].count
        cdn             = js_thumbs_slice[0].gsub(/\\\//m, ?/)[5..-1] + '/images/'

        to = thumbs_count if to > thumbs_count
        from.upto(to) { |i|
          return if errors == 3

          file     = "%03d.jpg" % i
          filename =  "#{cdn}#{file}"

          @pool.process {
            unless Dumper.get path, URI.parse(URI.encode(filename, '[]')), { referer: url }
              sleep 3
              errors += 1

              file = File.join(path, file).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
              File.delete(file) if File.exists? file
            end
          }
        }
      end
    end

    class << self
      def get_fakku(url, path, from = 1, to = 999)
        Fakku.new { |p|
          p.dump     url, path, from, to
          p.shutdown
        }
      end

      def info_fakku
        { from: :enabled, to: :enabled, type: :images }
      end
    end

  end
end
