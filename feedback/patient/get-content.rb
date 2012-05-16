#!/usr/bin/ruby

require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'active_support'
require 'json'
require 'find'

cgi = CGI.new

uid = cgi["uid"].to_i

res = {}

file = open("main-template.html")
body = file.read

if cgi["uid"] != "" then

	imgFiles = []
	imgAreaText = ""

	Find.find('../upload/resized/') {|f|
		if !File.directory?(f) then
			imgFiles.push f
		end
	}

	imgFiles = imgFiles.sort {|a, b| (-1) * (a <=> b) }

	maxImages = 10

	if imgFiles.length < maxImages then
		maxImages = imgFiles.length
	end

	i = 0
	while i < maxImages do
		imgAreaText = imgAreaText + "<li><img src='#{imgFiles[i]}'></li>\n"
		i = i + 1
	end

	db = SQLite3::Database.new("../../db/feedback.db")

	data = db.get_first_row("select * from messages where patient=? order by id desc", uid)

	db.close

	if !data.nil?

		date = data[1].to_s.unpack("a4a2a2")

		medicineText = ""

		if data[3] < 3 then
			medicineText = medicineText + "<div class='time'>朝</div>\n<img src='../img/fb#{data[3]}.png'>\n"
		end

		if data[4] < 3 then
			medicineText = medicineText + "<div class='time'>昼</div>\n<img src='../img/fb#{data[4]}.png'>\n"
		end

		if data[5] < 3 then
			medicineText = medicineText + "<div class='time'>夜</div>\n<img src='../img/fb#{data[5]}.png'>\n"
		end

		if data[6] < 3 then
			medicineText = medicineText + "<div class='time'>寝る前</div>\n<img src='../img/fb#{data[6]}.png'>\n"
		end

		body = body.gsub("%%month%%", date[1].to_i.to_s)
		body = body.gsub("%%day%%", date[2].to_i.to_s)
	
		body = body.gsub("%%message%%", data[7])
	
		body = body.gsub("%%medicine%%", medicineText)
	
		body = body.gsub("%%images%%", imgAreaText)
	else
		body = "<center><font size='7'><br /><br />現在、表示するメッセージはありません。</font></center>"
	end

	print "Content-type: text/html\n\n"
	print body

end
	
	
