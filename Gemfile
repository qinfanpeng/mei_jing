source 'https://rubygems.org'
#source 'http://ruby.taobao.org'

gem 'rails', '3.2.12'

gem 'therubyracer', :platforms => :ruby
gem "twitter-bootstrap-rails", '2.2.6'
gem 'bootstrap-will_paginate', '0.0.6'

gem 'slim'
gem 'slim-rails'
gem 'jquery-rails'

gem 'client_side_validations'
gem 'rails_kindeditor', '~> 0.4.0'
gem "paperclip", "~> 3.0"

gem 'sunspot_rails'
gem 'thin'

gem 'devise'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'rspec-rails', "~> 2.14.0"
  gem 'capybara', "~> 2.1.0"
  gem 'launchy'
end

group :test, :development do
  gem 'sqlite3'
  gem 'factory_girl_rails', '4.1.0'
	#  gem "capybara-webkit"
  gem 'database_cleaner'
	gem "selenium-webdriver"
end

group :production do 
  gem 'pg'
end

# Just for commandline tip output.
gem "colorize", "~> 0.5.8"
gem 'progress_bar'
