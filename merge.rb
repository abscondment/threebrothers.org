#!/usr/bin/env ruby

require 'fileutils'
require 'pp'
require 'yaml'

Dir.glob('public/blog/**/*.markdown') do |post_path|
  root_path = File.dirname(post_path)

  puts "CHECKING:"
  puts "\t#{post_path}"
  yaml_path = File.join(root_path, File.basename(post_path).gsub('.markdown', '.yaml'))

  begin
    yaml = YAML.load(File.read yaml_path)
  rescue Errno::ENOENT
    yaml = {}
  end

  post = File.read(post_path)
  new_path  = File.join(root_path, 'index.markdown')

  merged =

  File.open(new_path, 'w') do |file|
    file << [
    '---',
    (format('date:  %s', yaml['created_at'].strftime('%Y-%m-%d')) if yaml.key?('created_at')),
    (format('title: %s', yaml['title']) if yaml.key?('title')),
    '---',
    post,
    nil,
  ].join("\n")
  end
end
