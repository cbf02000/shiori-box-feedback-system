shiori-box-feedback-system
==========================

Shiori Box Feedback System


-- 動作確認 --

Ubuntu 10.04 + Apache2 + ruby 1.8.7 + rubygems


-- requireされているGemパッケージ --

require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'active_support'
require 'RMagick'
require 'json'
require 'find'


-- 準備手順 --

1. 上記環境に必要なGemパッケージを入れる
2. ApacheのDirectoryに /path/to/sbox/feedback を追加
3. 上記ApacheのDirectoryでRubyのCGIを実行できるように権限付与
4. $ sh /path/to/sbox/setup.sh を実行
