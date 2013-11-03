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
require 'uri'
require 'optparse'
require 'net/http'
require 'nokogiri'
require 'openssl'
require 'certified'
require 'addressable'
require 'base64'

require 'dumper/utils'
Dir.glob(File.expand_path("../dumper/profiles/*.rb", __FILE__)).each { |f|
  require "dumper/profiles/#{File.basename(f).split(?.)[0]}"
}
require 'dumper/dumper'

require 'dumper/version'