#!/usr/bin/ruby

require 'open-uri'
#require 'mysql2'

#client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => '', :database => 'radio_development')
url = "http://koit.tunegenie.com/onair/"

n = 0 # number of main loops
m = 0 # current total sleep time 
sleepTime = 15

loop do

	songs = []
	songAttr = {}

	open(url){|f|
		f.each_line{|row|
			#puts row
			row.chomp!
			if /slot_id:"(.*)"/ =~ row
				songAttr["slot_id"] = Time.at($1[0..9].to_i)
			elsif /length:(.*),/ =~ row
				songAttr["length"] = $1
			elsif /artistName:"(.*)"/ =~ row
				songAttr["artistName"] = $1
			elsif /artistSlug:"(.*)"/ =~ row
				songAttr["artistSlug"] = $1
			elsif /trackSlug:"(.*)"/ =~ row
				songAttr["trackSlug"] = $1
			elsif /trackName:"(.*)"/ =~ row
				songAttr["trackName"] = $1
			elsif /albumName:"(.*)"/ =~ row
				songAttr["albumName"] = $1
			elsif /albumSlug:"(.*)"/ =~ row
				songAttr["albumSlug"] = $1
			elsif /altitem:(.*)/ =~ row
				songAttr["altitem"] = $1
				songs << songAttr
				songAttr = {}
			else
			end
		}
	}

	currentSong = songs.pop
	startTime = currentSong["slot_id"].to_i
	playTime = currentSong["length"].to_i
	endTime = startTime + playTime
	now = Time.new.to_i
	adjustment = 8
	timeUntilNextSong = endTime - now + adjustment

		#puts "TimeUntilNextSong: #{timeUntilNextSong}"
		puts lyrics_url = "http://koit.tunegenie.com/music/#{currentSong["artistSlug"]}/_/#{currentSong["trackSlug"]}/+lyrics/"
		p currentSong

	if timeUntilNextSong > 0

		puts "--------------------------------------------------------------------------------"
		puts ""
		puts "  Play from      : #{currentSong["slot_id"]}"
		puts "  Ends at        : #{Time.at(endTime)}"
		puts "  Artist Name    : #{currentSong["artistName"]}"
		puts "  Track Name     : #{currentSong["trackName"]}"
		puts "  Alubum Name    : #{currentSong["albumName"]}"
		puts ""

		lyrics_url = "http://koit.tunegenie.com/music/#{currentSong["artistSlug"]}/_/#{currentSong["trackSlug"]}/+lyrics/"

		f = open(lyrics_url).read
		if /<div id="lyrictext" style="min-height:250px;">(.*?)<\/div>/m =~ f
			lyricArray = $1.gsub(/\n|\r/,'').split(/<br>|<p>/)

			lyricArray.each{|line|
				puts "   * #{line}"
			}

			lyricText = lyricArray.join("@")
			#p lyricArray
			#p lyricText

		else
			puts "Could not find out the lyric in the page"
		end


=begin
		# Insert to DB
		artistName = client.escape("#{currentSong["artistName"]}")
		trackName = client.escape("#{currentSong["trackName"]}")
		albumName = client.escape("#{currentSong["albumName"]}")
		lyricText = client.escape("#{lyricText}")
		#client.query("INSERT INTO songs (slot_id, length, artistName, trackName, albumName, lyric) VALUES ('#{currentSong["slot_id"]}', '#{currentSong["length"]}', '#{currentSong["artistName"]}', '#{currentSong["trackName"]}', '#{currentSong["albumName"]}', \"#{lyricText}\")")
		client.query("INSERT INTO songs (slot_id, length, artistName, trackName, albumName, lyric) VALUES ('#{currentSong["slot_id"]}', '#{currentSong["length"]}', '#{artistName}', '#{trackName}', '#{albumName}', '#{lyricText}')")
		#client.query("INSERT INTO songs (artistName) VALUES ('#{currentSong["artistName"]}')")
		#puts currentSong["slot_id"], currentSong["length"], currentSong["artistName"], currentSong["trackName"], currentSong["albumName"], lyricText
=end

		sleep timeUntilNextSong

	else

		n = n + 1 
		m = m + sleepTime
		puts "[#{n}]: #{Time.at(Time.now)} : Waiting for next song... #{m}sec"
		sleep sleepTime

	end


end
