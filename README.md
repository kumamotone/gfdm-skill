GITADORA スキルシミュレータ
===

KONAMI の音楽ゲーム GITADORA のスキル(腕前) シミュレータ．
http://tri.gfdm-skill.net/ で運営中．
GuitarFreaks & DrumMania Skill Simulator (http://xv-s.heteml.jp/skill/) の代替を目指して作成しましたが，独自の機能も備えています．

### フレームワーク

Ruby on Rails (4.1.9)

#### CSS フレームワーク

bootstrap-sass (3.2.0.2)

#### その他使用している主な gem

devise (認証用)
jquery-datatables-rails (スキル表などのテーブルの高機能化)
select2-rails (便利なセレクトボックス)

### 実行環境

#### Development

OS: Ubuntu 14.04 LTS (on VMware Workstation)
DB: SQLite3

### お借りしました

favicon は以下を加工しました．なんとパブリックドメイン

GATAG｜フリーイラスト素材集
http://free-illustrations.gatag.net/tag/%E5%8A%9B%E3%81%93%E3%81%B6

#### Production

PaaS: Sqale (http://sqale.jp/)
DB: MySQL2

### 開発に参加したい

いないと思いますが居たらフォークしてください．


```
$ git clone https://github.com/kumamotone/gfdm-skill.git
```

gem をインストール (mysql がインストールできないよとか怒られる場合は Gemfile の `gem 'mysql2'` をコメントアウト)

```
$ bundle install
```

マイグレーション

```
$ bundle exec rake db:migrate
```

曲データの登録

```
$ bundle exec rake db:seed
```

サーバを起動

```
$ rails s
```

`localhost:3000` にアクセスするとたぶん動いてるので動作の確認ができます．
あとはおもむろにブランチを作って

```
$ git checkout -b my-new-feature
```

変更したらコミットしてプッシュして

```
$ git commit -am "add: なんかあたらしいの"
$ git push origin my-new-feature
```

プルリクエストを投げてください．
Rails チュートリアルに基づいて作り始めたので rspec とか Guard とか入れてますが結局早々にテストを書くことを諦めてしまい色々お察しなことになっています．ちゃんとテスト書けるようになりたい
