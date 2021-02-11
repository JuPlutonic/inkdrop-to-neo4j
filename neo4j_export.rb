require 'uri'
require 'neo4j_ruby_driver'

driver = Neo4j::Driver::GraphDatabase.driver('bolt://0.0.0.0:7687',
                                             Neo4j::Driver::AuthTokens.basic('neo4j','hello'),
                                             encryption: false)

 driver.session do |session|
   session.write_transaction do |tx|
     tx.run("CREATE (a:Greeting) SET a.message = $message RETURN a.message + ', from node ' + id(a)",
                     message: 'hello, world')
   end
 end

 driver.session do |session|
   session.read_transaction do |tx|
     tx.run('MATCH (n) RETURN n')
   end
 end.each { |record| pp record }
