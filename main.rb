require 'pp'
require 'json'

require_relative './neo4j_import'
require_relative './parse_inkdrop_backup_folder'

inkdrop = ParseInkdropBackupFolder.new.call('./data/*.json')

puts
puts "Parse InkDrop backup files:"
puts "notes: #{inkdrop[:notes].count} tags: #{inkdrop[:tags].count} books: #{inkdrop[:books].count}"
puts

db = GraphDB.new

puts 'Create tag nodes'

db.create_tag_nodes(inkdrop[:tags])

puts 'Create book nodes'

db.create_book_nodes(inkdrop[:books])

puts 'Create book relations'

db.create_book_relations(inkdrop[:books])

puts 'Create note nodes'

db.create_note_nodes(inkdrop[:notes])
