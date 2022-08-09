source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.1.2"
gem "bcrypt", "3.1.13"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap-sass", "3.4.1"
gem "config"
gem "faker"
gem "jbuilder", "~> 2.7"
gem "mysql2", ">= 0.4.4"
gem "pagy"
gem "psych", "~> 3.1"
gem "puma", "~> 4.1"
gem "rails", "~> 6.1.0", ">= 6.1.0"
gem "rails-i18n"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 5.0"

gem "net-imap", require: false
gem "net-pop", require: false
gem "net-smtp", require: false

group :development, :test do
  gem "pry", "~> 0.14.0"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end

group :development do
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
