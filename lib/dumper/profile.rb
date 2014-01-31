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
  class Profile
    include Dumper
    include Observable

    def initialize(&block)
      add_observer Dumper::Logger.new
      
      min = pool_size[:min]
      max = pool_size[:max]

      @pool = Thread.pool min, max
      changed
      notify_observers error:  "Using #{min}:#{max || min} threads..."

      instance_eval &block
    end

    def dump(url, path, *args)
      raise NotImplementedError
    end

    def shutdown
      @pool.shutdown
    end
  end
end