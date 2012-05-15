#!/usr/bin/ruby

require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'active_support'
require 'json'

cgi = CGI.new

sendto = cgi["sendto"].to_i
uid = cgi["uid"].to_i

db = SQLite3::Database.new("../../db/feedback.db")

data = db.get_first_row("select * from patients where id=?", uid)

res = {}

if data[1] == 0 then
	res = {"code" => "0"}
elsif data[1] == 1 then
	res = {"code" => "1"}
end

print "Content-type: application/json\n\n"

print res.to_json
