require 'uri'
require 'neo4j_ruby_driver'

# driver = Neo4j::Driver::GraphDatabase.driver('bolt://0.0.0.0:7687',
#                                             Neo4j::Driver::AuthTokens.basic('neo4j','hello'),
#                                             encryption: false)
#
# driver.session do |session|
#   session.write_transaction do |tx|
#     tx.run("CREATE (a:Greeting) SET a.message = $message RETURN a.message + ', from node ' + id(a)",
#                     message: 'hello, world')
#   end
# end
#
# driver.session do |session|
#   session.read_transaction do |tx|
#     tx.run('MATCH (n) RETURN n')
#   end
# end.each { |record| pp record }

class GraphDB
  attr_reader :driver

  def initialize
     @driver = Neo4j::Driver::GraphDatabase.driver('bolt://0.0.0.0:7687',
                                                   Neo4j::Driver::AuthTokens.basic('neo4j','hello'),
                                                   encryption: false)
  end

  def create_tag_nodes(tags)
    tags.each do |tag|
      driver.session { |session| session.run("CREATE (t:Tag { id: $id, title: $title }) RETURN t",
                                             id: tag[:id],
                                             title: tag[:title]
                                            ) }
    end
  end

  def create_book_nodes(books)
  books.each do |book|
    driver.session { |session| session.run("CREATE (t:Book { id: $id, title: $title }) RETURN t",
                                           id: book[:id],
                                           title: book[:title]
                                          ) }
  end
end                                                                                             end
