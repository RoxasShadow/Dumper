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

    def self.get_fakku(url, path, from = 1, to = 999)
      puts from
      puts to
      abort
      url    += '/read' unless url.end_with? '/read'
      errors = 0
      
      cdn = open(url).read.split('window.params.thumbs')[1].split('\/thumbs\/')[0].gsub(/\\\//m, ?/)[5..-1] + '/images/'

      ua  = 'Mozilla/5.0 (Windows NT 6.2; WOW64; rv:16.0) Gecko/20100101 Firefox/16.0'
      ref = url

      from.upto(to) { |i|
        return if errors == 10
        
        file     = "%03d.jpg" % i
        filename =  "#{cdn}#{file}"

        unless self.get path, URI.parse(URI.encode(filename, '[]')), ua, ref
          errors += 1
          
          file = File.join(path, file).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
          File.delete(file) if File.exists? file
        end
      }
    end

    def self.info_fakku
      { :from => true, :to => true }
    end

  end
end