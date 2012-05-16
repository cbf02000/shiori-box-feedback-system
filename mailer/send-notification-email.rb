#!/usr/bin/ruby

require 'rubygems'
require 'tmail'
require '../../mailer/class/JMail'

sendto = "delfiini40.77@docomo.ne.jp"
#sendto = "dans@sfc.wide.ad.jp"

uid = ARGV[0]
msgid = ARGV[1]
print uid + "   " + msgid
body = "Shiori Box #{uid} にて、新規メッセージ（ID: #{msgid}）が患者さんによって確認されました。"

jmail = JMail.new()

jmail.set_account('mail.sfc.wide.ad.jp', 587, 'shiori', '40ri0816', 'shiori@sfc.wide.ad.jp')
jmail.set_to(sendto)
jmail.set_subject("Shiori Box #{uid} 確認通知")
jmail.set_text(body)
jmail.send
