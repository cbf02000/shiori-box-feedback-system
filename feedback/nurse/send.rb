#!/usr/bin/ruby

require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'active_support'

cgi = CGI.new

sendto = cgi["sendto"].to_i
id = cgi["id"].to_i

db = SQLite3::Database.new("../../db/feedback.db")

db.execute("update patients set new='1' where id=?", sendto)
db.execute("update patients set message_id=? where id=?", id, sendto)
db.execute("update messages set sent='1' where id=?", id)

db.close

print <<EOS
Content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>送信完了</title>
	</head>
<body>
<center>
<h1>送信完了</h1>
<p><a href="index.html">戻る</a></p>
</center>
</body>
</html>
EOS
