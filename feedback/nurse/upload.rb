#!/usr/bin/ruby

require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'RMagick'
require 'active_support/all'

def getText(id)
	if id == 0 then
		return "飲んだ"
	elsif id == 1 then
		return "飲んでない"
	elsif id == 2 then
		return "不明"
	elsif id == 3 then
		return "関係無し"
	end
end

cgi = CGI.new

id = Time.now.to_i

text = cgi["body"].read
asa = cgi["asa"].read.to_i
hiru = cgi["hiru"].read.to_i
yoru = cgi["yoru"].read.to_i
neru = cgi["neru"].read.to_i
year = cgi["yy"].read
mon = cgi["mm"].read
day = cgi["dd"].read
sendto = cgi["sendto"].read.to_i
image = cgi['image'].read

textOK = 0
newimage = 0

date = "%04d" % year + "%02d" % mon + "%02d" % day

if image.blank? == false then

	open("../upload/temp.jpg","w") do |fh|
		fh.binmode
		fh.write image
	end

	newimage = 1

	maxHeight = 350
	maxWidth = 500

	img = Magick::ImageList.new("../upload/temp.jpg")
	res = img.resize(maxWidth, maxHeight)
	res.write("../upload/resized/#{id}.jpg")
end

if text != "" then
	text = text.gsub(/\r\n?/,"<br />")
	textOK = 1
end

db = SQLite3::Database.new("../../db/feedback.db")

db.execute("insert into messages values (?, ?, ?, ?, ?, ?, ?, ?)", id, date, sendto, asa, hiru, yoru, neru, text)

db.close

print <<EOS
Content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>入力内容確認</title>
	</head>
<body>
<center>
<h1>入力内容確認</h1>
<h3>送信先：Shiori Box #{sendto}</h3>
<h3>日付：#{year}年#{mon}月#{day}日</h3>

  <table style="text-align:center;" border="1">
   <tr>
    <td width="120px">朝</td>
    <td width="120px">昼</td>
    <td width="120px">夜</td>
    <td width="120px">寝る前</td>
   </tr>
   <tr>
    <td width="120px">#{getText(asa)}<br /></td>
    <td width="120px">#{getText(hiru)}<br /></td>
    <td width="120px">#{getText(yoru)}<br /></td>
    <td width="120px">#{getText(neru)}<br /></td>
   </tr>
  </table>
EOS

if textOK == 1 then
	print "<h3>メッセージ</h3>#{text}"
else
	print "<h3>メッセージ無し</h3>"
end

if newimage == 1 then
	print "<h3>アップロード画像</h3><img src=\"../upload/resized/#{id}.jpg\">"
else
	print "<h3>アップロード画像無し</h3>"
end

print <<EOS2
<h3><a href="#" onClick="history.back(); return false;">前のページにもどる</a> / 
<a href="send.rb?sendto=#{sendto}&id=#{id}">送信</a></h3>
</center>
</body>
</html>
EOS2
