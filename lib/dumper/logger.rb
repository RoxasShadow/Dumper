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
  class Logger

    class << self
      def redirect_on(where, file)
        @@where = where
        @@file  = !file || file.empty? ? 'dumper.log' : file
      end

      def log_on_file(file, data)
        File.open(file, ?a) do |file|
          data.each do |status, message|
            file.puts status == :critical_error_dump ? message.inspect : message
          end
        end
      end

      def log_on_screen(data)
        data.each do |status, message|
          if status == :critical_error_dump
            p message
          else
            puts message
          end
        end
      end
    end

    def initialize
      @@where = :screen
    end

    def update(data)
      if @@where == :file
        Logger.log_on_file @@file, data
      else
        Logger.log_on_screen(data) if Dumper.verbose?
      end
    end

  end
end
