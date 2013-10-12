#!/usr/bin/ruby

require 'mysql2'
client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => '', :database => 'radio_development')

#client.query("INSERT INTO songs (slot_id, length, artistName, trackName, albumName, lyric) VALUES ("2012-06-13 18:26:16", "bbbb")")
#client.query("INSERT INTO songs (slot_id) VALUES ('2012-06-13 18:26:16')")
#client.query("INSERT INTO songs (slot_id) VALUES ('2012-06-13 18:26:16 -0700')")
text = client.escape("I can't wait")
client.query("INSERT INTO songs (trackName) VALUES ('#{text}')")

=begin
| id         | int(11)      | NO   | PRI | NULL    | auto_increment |
| slot_id    | datetime     | YES  |     | NULL    |                |
| length     | int(11)      | YES  |     | NULL    |                |
| artistName | varchar(255) | YES  |     | NULL    |                |
| trackName  | varchar(255) | YES  |     | NULL    |                |
| albumName  | varchar(255) | YES  |     | NULL    |                |
| lyric      | text         | YES  |     | NULL    |                |
| created_at | datetime     | NO   |     | NULL    |                |
| updated_at | datetime     | NO   |     | NULL    |         
=end



=begin
client.query("INSERT INTO songs (ArtistName, TrackName) VALUES ('aaaa', 'bbbb')")
client.query("SELECT * FROM songs").each do |a|
=end


