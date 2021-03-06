#!/usr/bin/ruby

require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'active_support'
require 'json'

cgi = CGI.new

uid = cgi["uid"].to_i
msgid = cgi["msg"].to_i

res = {}

if cgi["uid"] != "" then

	db = SQLite3::Database.new("../../db/feedback.db")

	data = db.get_first_row("update patients set new=0 where id=?", uid)
	data = db.get_first_row("update messages set read=1 where id=?", msgid)

	db.close

	cmd = "../../mailer/send-notification-email.rb #{uid.to_s} #{msgid.to_s}"
	system(cmd)

	res = {"code" => "0"}
else
	res = {"code" => "-1"}
end
	
print "Content-type: application/json\n\n"
print res.to_json

