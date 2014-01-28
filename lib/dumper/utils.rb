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

class URI::Parser
  def split url
    a = Addressable::URI::parse url
    [a.scheme, a.userinfo, a.host, a.port, nil, a.path, nil, a.query, a.fragment]
  end
end