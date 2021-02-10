require 'pp'
require 'json'

# require_relative './neo4j'

files = Dir.glob('./data/*.json').map do |file_name|
  JSON.parse(File.read(file_name))
end
