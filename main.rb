# require 'pp'
require 'json'

# require_relative './neo4j'
require_relative './parse_inkdrop_backup_folder'

inkdrop = ParseInkdropBackupFolder.new.call('./data/*.json')

puts
puts "Parse InkDrop backup files:"
puts "notes: #{inkdrop[:notes].count} tags: #{inkdrop[:tags].count} books: #{inkdrop[:books].count}"
puts

