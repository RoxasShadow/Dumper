#! /usr/bin/env ruby
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

require './profiles.rb'
require 'uri'
require 'optparse'

class String

  def numeric?
    self.to_i.to_s == self || self.to_f.to_s == self
  end
  
  def sanitize_filename
    self.split(/(?<=.)\.(?=[^.])(?!.*\.[^.])/m).map { |s| s.gsub /[^a-z0-9\-]+/i, ?_ }.join(?.)
  end
  
end

class NilClass
  def numeric?
    false
  end  
end

options = {}

if ARGV.empty?  
  abort 'Profiles available:'.tap { |s|
    Dumper::Profiles::list.each { |p| s << "\n" + (' ' * 3) + p }
  }
end

OptionParser.new do |o|
  options[:url]     = []
  options[:path]    = []
  options[:pages]   = 1
  
  o.on '-l', '--list', 'Show available profiles' do
    puts Dumper::Profiles::list.join "\n"
    exit
  end
  
  o.on '-u', '--url URL', 'Target URL' do |url|
    options[:url] << url
  end
  
  o.on '-f', '--file FILE', 'File containing a list of URLs, a double pipe (||) and the target folder, one per line' do |file|
    file = File.open(file).read.gsub(/\r\n?/, "\n")
    file.each_line { |line|
      split             = line.split('||')
      options[:url]     << split[0].strip
      options[:path]    << split[1].strip
    }
  end
  
  o.on '-p', '--path PATH', 'Target folder' do |path|
    options[:path] << path
  end
  
  o.on '-x', '--xpath XPATH', 'Custom xpath' do |xpath|
    options[:xpath] = xpath
  end
  
  o.on '-g', '--pages PAGES', 'Pages to save (if allowed)' do |pages|
    options[:pages] = pages.to_i
  end
end.parse!

if options[:url].empty?
  abort 'URL or list of URLs is required.'
elsif options[:path].empty?
  abort 'Path is required.'
end

begin      
  options[:url].each_with_index { |url, i|
    begin
      host = URI.parse(url).host.split(?.)[-2]
      Dir.mkdir(options[:path][i]) unless File.directory? options[:path][i]
      if Dumper::Profiles::list.include? host
        method = ('get_' + host.gsub(?-, ?_)).to_sym
        Dumper::Profiles::send method, url, options[:path][i], options[:pages]
      else
        Dumper::Profiles::get_generic  url, options[:path][i], options[:xpath]
      end
    rescue Nokogiri::XML::XPath::SyntaxError => e
      puts e.to_s.gsub(/expression/, 'xpath')
      puts 'Cannot dump.'
    rescue OpenURI::HTTPError => e
      puts "Error opening #{url}: #{e}" 
    rescue URI::InvalidURIError => e
      puts "URL #{url} is not valid: #{e}"
    end
  }
end