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

require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'base64'

module Dumper; module Profiles

  ### Helpers ###
  
  def self.list
    [ '4chan', 'multiplayer', 'wallpaperhere', 'sankakucomplex', 'mangaeden', 'fakku' ]
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
  
  ### Default profiles ###

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
  
  ### Custom profiles ###

  def self.get_4chan(url, path, pages)
    Nokogiri::HTML(open(url)).xpath('//a[@class = "fileThumb"]/@href').each { |p|
      self.get path, 'http:' + p.to_s
    }
  end

  # Pages to download available
  def self.get_multiplayer(url, path, pages)
    url += '?pagina=1' unless url.split(??).last.start_with? 'pagina'
    
    1.upto(pages) { |i|
      Nokogiri::HTML(open(url+i.to_s)).xpath('//div[@class="thumb"]/a/@href').each { |p|
        next unless p.to_s.start_with? '/immagini/'
        
        Nokogiri::HTML(open("http://multiplayer.it#{p}")).xpath('//a[@class="button"]/@href').each { |u|
          self.get path, u
        }
      }
    }
  end
  
  # Category URL at the starting page + pages to download
  def self.get_wallpaperhere(url, path, pages)
    start = url[/\/page\/.+?\//].delete('/page/').to_i || 1
    url   = url.sub /\/page\/.+?\//, '/page/$PAGE/'
    start.upto(pages) { |page|
      u = url.gsub('$PAGE', page.to_s)
      Nokogiri::HTML(open(u)).xpath('//div[@class="wallpapers_list mt10 clearfix"]/ul[@class="clearfix"]/li').each { |p|
        p = p.xpath('a/@href').to_s
        size = Nokogiri::HTML(open('http://www.wallpaperhere.com' + p + '/download_preview')).xpath('//dl[@class="wp_rel"]/dd')[0].text
        Nokogiri::HTML(open('http://www.wallpaperhere.com' + p + '/download_' + size)).xpath('//div[@class="download_img"]/div/img/@src').each { |q|
          self.get path, 'http://www.wallpaperhere.com' + q.to_s
        }
      }
    }
  end
  
  # Pages to download available
  ### ALMOST BROKEN ###
  def self.get_sankakucomplex(url, path, pages)
    if url.include?('idol.sankakucomplex') || url.include?('chan.sankakucomplex')
      url.gsub!('index', 'index.content')
      1.upto(pages) { |page|
        u = url + "&page=#{page}"
        op = open(u)
        begin
          Nokogiri::HTML(open(u)).xpath('//a/@href').each { |p|
            p = url.gsub(/post(.+)/, p.to_s)
            begin
              Nokogiri::HTML(open(p)).xpath('//a[@id="image-link"]/img/@src').each { |q|
                self.get path, q
              }
            rescue Exception => e
              sleep 1
              retry
            end
          }
        rescue Exception => e
          sleep 1
          retry
        end
      }
    else
      Nokogiri::HTML(open(url)).xpath('//a[@class="highslide"]/@href').each { |p|
        self.get path, p
      }
    end
  end
  
  def self.get_mangaeden(url, path, pages)
    Nokogiri::HTML(open(url)).xpath('//a[@class="chapterLink"]').each { |p|
      i = 1
      
      dir = File.join path, "#{p.children[1].text} - #{p.children[3].text.sanitize_filename}"
      Dir.mkdir(dir) unless File.directory? dir
      
      Nokogiri::HTML(open("http://www.mangaeden.com#{p['href']}")).xpath('//img[@id="mainImg"]/@src').each { |r|
        self.get dir, r, '', '', "1.png"
        i += 1
      }
      
      Nokogiri::HTML(open("http://www.mangaeden.com#{p['href']}")).xpath('//a[@class="ui-state-default"]').each { |q|
        next unless q.text.numeric?        
        q = q['href']
                  
        Nokogiri::HTML(open("http://www.mangaeden.com#{q}")).xpath('//img[@id="mainImg"]/@src').each { |r|
          self.get dir, r, '', '', "#{i}.png"
          i += 1
        }
      }
    }
  end
  
  def self.get_fakku(url, path, pages)
    url += '/read' unless url.end_with? '/read'
    errors = 0
    
    cdn = Net::HTTP.get(URI.parse(url))[%r{return '(http://cdn\.fakku\.net.*?)'}, 1]
    
    1.upto(999) { |i|
      return if errors == 10
      
      file = "%03d.jpg" % i
      filename =  "#{cdn}#{file}"
      
      unless self.get path, filename
        errors += 1
        
        file = File.join(path, file).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
        File.delete(file) if File.exists? file
      end
    }    
  end
  
end; end
