source 'https://rubygems.org'
ruby '2.4.9'
#ruby-gemset=railstutorial_rails_4_0

# gem 'json', github: 'flori/json', branch: 'v1.8'
gem 'rails', github: 'rails/rails', branch: '4-2-stable'
gem 'rake', '< 11.0'
gem 'bootstrap-sass', '3.2.0.4' #, '2.3.2.0'
gem 'sprockets', '2.12.5'
gem 'bcrypt-ruby', '3.1.2'
#gem 'will_paginate', '3.0.4'
gem "jquery-turbolinks" # Turbolinksで遷移したときもjQuery.ready()を呼び出してくれる
gem "select2-rails"
gem 'jquery-datatables-rails'
gem 'google-analytics-turbolinks'
gem 'devise', '3.5.1'
gem 'rails_admin', '0.8.1'
gem 'nprogress-rails'

gem 'sass-rails', '4.0.5'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails', '3.0.4'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'
  
gem 'mysql2', '0.3.21'
gem 'twitter', '5.16.0'

group :development, :test do
  gem 'sqlite3', '1.4.2' 
  gem 'debug_inspector', '0.0.2'
  gem 'pry-rails'  # rails console(もしくは、rails c)でirbの代わりにpryを使われる
  gem 'pry-doc'    # methodを表示
  gem 'pry-byebug' # デバッグを実施(Ruby 2.0以降で動作する)
  gem 'pry-stack_explorer' # スタックをたどれる

  gem 'rspec-rails', '2.13.1'
  gem 'guard', '2.6.1'
  gem 'guard-rspec', '2.5.0'
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'   # guard-spork を使うときに起こる問題を解決するものらしい

  gem 'dotenv-rails'     # .env ファイルから設定を持ってくる(使ってない？)

  gem 'better_errors'    # エラー画面がいい感じになるらしい
  gem 'binding_of_caller'# better_errorsの画面上にirb/pry(PERL)を表示する
  gem 'rails_best_practices' # Rails のベストプラクティスに従っているかチェック
  
  # gem 'annotate'         # スキーマ情報をモデルに書いてくれるらしい
  # gem 'bullet'              # n+1問題を発見してくれるらしい
end

group :test do
  gem 'factory_girl_rails', '4.2.1'
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'

  # Uncomment this line on OS X.
  # gem 'growl', '1.0.3'

  # Uncomment these lines on Linux.
  gem 'libnotify', '0.8.0'

  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'win32console', '1.3.2'
end

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  # heroku 
  #gem 'pg', '0.15.1'
  #gem 'rails_12factor', '0.0.2'

  # sqale
  # gem 'mysql2', '0.3.20'
end
