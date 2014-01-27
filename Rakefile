#! /usr/bin/env ruby
require 'rake'

task :default => [ :build, :install, :test ]

task :build do
  sh 'gem build *.gemspec'
end

task :install do
  sh 'gem install *.gem'
end

task :test, :spec do |t, args|
  if args[:spec]
    sh "rspec spec/#{args[:spec]}_spec.rb --backtrace --color --format doc"
  else
    sh "parallel_rspec spec/"
  end
end