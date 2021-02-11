##### Description
This script parses into graphes (NEO4J) backuped notes from [InkDrop(R)](https://inkdrop.app/) desktop app
> folder 'data' copyed from the backup place here to the script's folder).

###### Considerations
Fast script what uses only pattern matching.
No need to slow🐌️-work with exported Markdown-files
> (parse inkdrop:// into HTML tokenizing it before adding to NEO4J database).

###### Additional software
seabolt-1.7.4-Linux-ubuntu-18.04.deb
gem 'neo4j-ruby-driver'
neo4j app from repository:
sudo add-apt-repository "deb https://debian.neo4j.com stable 4.1"

###### Deployment: Heroku
Add a Neo4j db to your application:

> To use GrapheneDB:
heroku addons:create graphenedb

> To use Graph Story:
heroku addons:create graphstory
