# README
## 概 要
githubでissueがassignされたときと、pul requestを作成し更新されたときにデスクトップ通知を受け取ることができます。webブラウザ上で動作します。

## 開発背景
チーム開発をしていて、issueがassignされたときやpull requestにコメントされたときにすぐに知りたいと思ったため作ろうと思いました。  
また、様々な開発現場で対応できるようにwebブラウザで動作するようにしてOSによらないアプリにしたいとも思ったため、webアプリ形式にしました。

## 動作確認環境
OSはmacOS、DBはsqlite3、ブラウザはGoogle Chrome、Firefoxで動作確認しています。

## Setup
rubyのバージョンは2.5.3になります。  
```cassandraql
$ git clone https://github.com/Koki-Onishi/github_notifier
$ cd github_notifier
$ gem install bundler
$ bundle i --path vendor/bundle
$ bundle exec rake db:migrate
$ bundle exec rails c
```

## Demo
デモページのリンクです。Heroku上で動作しています。  
[デモページ](https://github-notifier-koki.herokuapp.com/)
