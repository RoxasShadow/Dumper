#--
# Copyright(C) 2013 Giovanni Capuano <webmaster@giovannicapuano.net>
#
# This file is part of Dumper.
#
# Smogon-API is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Smogon-API is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Smogon-API.  If not, see <http://www.gnu.org/licenses/>.
#++

require 'open-uri'
require 'net/http'
require 'uri'
require 'optparse'
require 'base64'
require 'nokogiri'
require 'openssl'
require 'certified'
require 'addressable/uri'
require 'json'
require 'thread/pool'

require 'dumper/utils'
require 'dumper/dumper'
require 'dumper/version'

Dir.glob(File.expand_path("../dumper/profiles/*.rb", __FILE__)).each { |f|
  require "dumper/profiles/#{File.basename(f).split(?.)[0]}"
}
