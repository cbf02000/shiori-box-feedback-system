#!/usr/bin/ruby

require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'active_support'
require 'json'
require 'find'

def getText(id)
	if id == 0 then
		return "○"
	elsif id == 1 then
		return "✕"
	elsif id == 2 then
		return "△"
	elsif id == 3 then
		return "―"
	end
end


cgi = CGI.new

uid = cgi["uid"].to_i

file = open("messages-template.html")
body = file.read

if cgi["uid"] != "" then

	messagesText = ""
	
	db = SQLite3::Database.new("../../db/feedback.db")

	db.execute("select * from messages where patient=? and sent=1 order by id desc", uid) do |row|
		
		rowText = ""

		if row[9] == 0 then
			rowText = rowText + "<tr bgcolor='#DB7093' height='100px'>\n"
		elsif row[9] == 1 then
			rowText = rowText + "<tr bgcolor='#90EE90' height='100px'>\n"
		end

		date = row[1].to_s.unpack("a4a2a2")
		rowText = rowText + "<td>#{row[0]}</td>\n"
		rowText = rowText + "<td>#{date[0]}/#{date[1]}/#{date[2]}</td>"
		rowText = rowText + "<td>#{getText(row[3])}</td>\n"
		rowText = rowText + "<td>#{getText(row[4])}</td>\n"
		rowText = rowText + "<td>#{getText(row[5])}</td>\n"
		rowText = rowText + "<td>#{getText(row[6])}</td>\n"
		rowText = rowText + "<td>#{row[7]}</td>\n"

		if row[9] == 0 then
			rowText = rowText + "<td>未読</td>\n"
		elsif row[9] == 1 then
			rowText = rowText + "<td>既読</td>\n"
		end

		rowText = rowText + "</tr>\n"

		messagesText = messagesText + rowText

	end

	body = body.gsub("%%box-id%%", "Shiori Box #{uid}")
	body = body.gsub("%%messages%%", messagesText)
	
	print "Content-type: text/html\n\n"
	print body

end
	
	
