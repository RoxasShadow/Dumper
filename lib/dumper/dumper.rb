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

module Dumper; module Profiles
  
  def self.list
    Dir.glob(File.expand_path('../profiles/*.rb', __FILE__)).sort { |a, b| b <=> a }.map { |f|
      f = File.basename(f).split(?.)[0]
    }
  end
  
  def self.get(path, p, ua = '', ref = '', filename = '')
    p = p.to_s
    
    begin
      if p.start_with? 'data:image/'
        filename = File.join path, filename == '' ? rand(1000).to_s + '.' + p.split('data:image/')[1].split(?;)[0] : filename
        filename.gsub!(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
        if File.exists? filename
          puts "File #{filename} already exists."
        else
          puts "Downloading base64 image as #{filename}..."
          p.gsub!(/data:image\/png;base64,/, '')
          File.open(filename, 'wb') { |f| f.write Base64.decode64(p) }
        end
      else
        filename = File.join path, filename == '' ? File.basename(p) : filename
        filename.gsub!(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
        if File.exists? filename
          puts "File #{filename} already exists."
        else
          filename = File.join path, rand(1000).to_s + '.jpg' unless filename[-4] == ?.
          puts "Downloading #{p} as #{filename}..."
          File.open(filename, 'wb') { |f| f.write open(p, 'User-Agent' => ua, 'Referer' => ref).read }
        end
      end
    rescue Exception => e
      p e
      puts "Error downloading \#{p}."
      return false
    end
    return true
  end

  def self.get_generic(url, path, xpath)
    uri = nil
    Nokogiri::HTML(open(url)).xpath(xpath).each { |p|
      if p.to_s.start_with? ?/
        uri = URI(url) if uri.nil?
        p   = "#{uri.scheme}://#{uri.host}#{p}"
      end
      self.get path, p
    }
  end
  
  def method_missing(method, *args, &block)
    "'#{method.split('get_')[1]}' profile not found."
  end
  
end; end