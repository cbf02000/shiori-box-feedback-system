#!/usr/bin/ruby

require 'rubygems'
require 'tmail'
require 'net/smtp'
require 'kconv'
require 'base64'
require 'tlsmail'

# 日本語メールクラス
class JMail
  # 初期化処理
  def initialize()
    @mail = TMail::Mail.new
    @mail.mime_version = '1.0'
  end
  # アカウントの設定
  def set_account(smtp_server, port, user, pass, from_address)
    @smtp_server = smtp_server
    @smtp_port = port
    @smtp_user = user
    @smtp_pass = pass
    @mail.from = from_address
    @mail.reply_to = from_address
  end
  # 宛先を設定する。
  def set_to(to_address)
    @mail.to = to_address
    @to_address = to_address
  end
  # タイトルを設定する。
  def set_subject(subject)
    work = Kconv.tojis(subject).split(//,1).pack('m').chomp
    @mail.subject = "=?ISO-2022-JP?B?"+work.gsub('\n', '')+"?="
  end
  # 本文を設定する。
  def set_text(text)
    main_text = TMail::Mail.new
    main_text.set_content_type 'text', 'plain', {'charset'=>'iso-2022-jp'}
    main_text.body = Kconv.tojis(text)
    @mail.parts.push main_text
  end
  # メールを送信する。
  def send()
    @mail.date = Time.now
    @mail.write_back
    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
    Net::SMTP.start(@smtp_server, @smtp_port, @smtp_server, @smtp_user, @smtp_pass, :plain) do |smtp|
      smtp.sendmail(@mail.encoded, @mail.from, @to_address)
    end
  end
  # ファイルを添付する。
  def set_attach(file_path)
    attach = TMail::Mail.new
    %r|(^.*)/(.+$)|.match(file_path)
    file_path, file_name = $1, $2
    tmp_file_path = File.expand_path(file_name,file_path)
    attach.body = Base64.encode64 File.read(tmp_file_path)
    attach.set_content_type 'application','zip','name'=>file_name
    attach.set_content_disposition 'attachment','filename'=>file_name
    attach.transfer_encoding = 'base64'
    @mail.parts.push attach
  end
end
