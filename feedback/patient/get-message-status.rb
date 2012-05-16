#!/usr/bin/ruby

require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'active_support'
require 'json'

cgi = CGI.new

uid = cgi["uid"].to_i

res = {}

if cgi["uid"] != "" then

	db = SQLite3::Database.new("../../db/feedback.db")

	data = db.get_first_row("select * from patients where id=?", uid)

	db.close

	if data[1] == 0 then
		res = {"code" => "0", "msg" => data[2].to_s}
	elsif data[1] == 1 then
		res = {"code" => "1", "msg" => data[2].to_s}
	end
else
	res = {"code" => "-1"}
end
	
print "Content-type: application/json\n\n"
print res.to_json
