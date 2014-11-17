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
  USER_AGENT = 'Mozilla/5.0 (Windows NT 6.2; WOW64; rv:16.0) Gecko/20100101 Firefox/16.0'

  def pool_size
    {
      min: @min || 4,
      max: @max
    }
  end

  def verbose?
    @verbose == nil || @verbose == true
  end
    alias_method :mute?, :verbose?

  def mute?
    @verbose == false
  end
    alias_method :muted?, :mute?

  class << self
    include Alakazam

    def pool_size=(min, max = nil)
      @min = min
      @max = max
    end

    def verbose=(verbose)
      @verbose = verbose
    end

    def shut_up!
      @verbose == false
    end
      alias_method :mute!,   :shut_up!

    def verbose!
      @verbose == true
    end
      alias_method :unmute!, :verbose!

    def verbose?
      @verbose == nil || @verbose == true
    end

    def list
      Dir.glob(File.expand_path('../profiles/*.rb', __FILE__)).sort { |a, b| b <=> a }.map { |f|
        f = File.basename(f).split(?.)[0]
      }
    end
    
    def get(path, url, options = {})
      url    = url.to_s
      errors = 0
      
      begin
        if url.start_with? 'data:image/'
          filename = File.join path, options[:filename] || rand(1000).to_s + '.' + url.split('data:image/')[1].split(?;)[0]
          filename.gsub! File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR

          url.gsub /data:image\/png;base64,/, ''

          if File.exists? filename
            notify_observers error:  "File #{filename} already exists."
          else
            notify_observers status: "Downloading base64 image as #{filename}..."
            File.open(filename, 'wb') { |f|
              f.write Base64.decode64(url)
            }
          end
        else
          filename = File.join path, options[:filename] || File.basename(url)
          filename.gsub! File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR

          if File.exists? filename
            notify_observers error:  "File #{filename} already exists."
          else
            filename = File.join(path, rand(1000).to_s + '.jpg') unless filename[-4] == ?. || filename[-5] == ?.
            notify_observers status: "Downloading #{url} as #{filename}..."

            File.open(filename, 'wb') { |f|
              f.write open(url,
                ssl_verify: OpenSSL::SSL::VERIFY_NONE,
                'User-Agent' => options[:user_agent] || USER_AGENT,
                'Referer'    => options[:referer   ] || url
              ).read
            }
          end
        end
      rescue Exception => e
        if errors <= 3
          errors += 1
          sleep 3
          retry
        else
          notify_observers critical_error: "Error downloading #{url}.", critical_error_dump: e
          return false
        end
      end
      
      true
    end

    def get_generic(url, path, xpath)
      uri = nil
      Nokogiri::HTML(open(url)).xpath(xpath).each { |p|
        if p.to_s.start_with? ?/
          uri = URI(url) if uri.nil?
          p   = "#{uri.scheme}://#{uri.host}#{p}"
        end
        get path, p
      }
    end
  end
  
  def method_missing(method, *args, &block)
    "'#{method.split('get_')[1]}' profile not found."
  end
end
