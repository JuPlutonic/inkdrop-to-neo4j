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
     @driver.session { |session| session.run("MATCH (n) DETACH DELETE n") }
  end

  def create_tag_nodes(tags)
    tags.each do |tag|
      driver.session do |session|
        session.run("
          CREATE (t:Tag { id: $id, title: $title })
          RETURN t
        ", id: tag[:id], title: tag[:title])
      end
    end
  end

  def create_book_nodes(books)
    books.each do |book|
      driver.session do |session|
        session.run("
          CREATE (t:Book { id: $id, title: $title })
          RETURN t
        ", id: book[:id], title: book[:title])
      end
    end
  end

  def create_book_relations(books)
    books.each do |book|
      driver.session do |session|
        session.run("
          MATCH (b:Book), (parent:Book)
          WHERE b.id = $id AND parent.id = $parent_id
          CREATE (b)-[r:PARENT_BOOK]->(parent)
          RETURN type(r)
        ", id: book[:id], parent_id: book[:parent_id])
      end
    end
  end

  def create_note_nodes(notes)
    notes.each do |note|
      driver.session do |session|
        session.run("
          CREATE (n:Note { id: $id, title: $title })
          RETURN n
        ", id: note[:id], title: note[:title])
      end
    end
  end

  def create_note_tag_relations(notes)
    notes.each do |note|
      note[:tags].each do |tag_id|
        driver.session do |session|
          session.run("MATCH (n:Note), (t:Tag)
                       WHERE n.id = $id AND t.id = $tag_id
                       CREATE (n)-[r:TAG]->(t) RETURN n
                      ", id: note[:id], tag_id: tag_id)
        end
      end
    end
  end

  def create_note_book_relations(notes)
    notes.each do |note|
      driver.session do |session|
        session.run("
          MATCH (n:Note), (b:Book)
          WHERE n.id = $id AND b.id = $book_id
          CREATE (n)-[r:BOOK]->(b)
          RETURN n
        ", id: note[:id], book_id: note[:book_id])
      end
    end
  end

  # rubocop:disable Metrics/MethodLength
  def create_note_relations(notes)
    notes.each do |note|
      note[:nested_notes].each do |note_id|
        driver.session do |session|
          session.run("
            MATCH (n:Note), (anoth:Note)
            WHERE n.id = $id AND anoth.id = $anoth_note_id
            CREATE (n)-[r:NESTED]->(anoth)
            RETURN n
          ", id: note[:id], anoth_note_id: note_id)
        end
      end
    # note[:related_notes].each do |note_id|
    #   driver.session do |session|
    #     session.run("
    #       MATCH (n:Note), (anoth:Note)
    #       WHERE n.id = $id AND anoth.id = $anoth_note_id
    #       CREATE (n)-[r:RELATED]->(anoth)
    #       RETURN n
    #     ", id: note[:id], anoth_note_id: note_id)
    #   end
    # end
    end
  end
end
