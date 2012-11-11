source 'http://rubygems.org'
gem 'sinatra'

gem 'hpricot'

gem 'data_mapper'

gem "sqlite3", :groups => [:development, :test]

gem 'dm-sqlite-adapter', :groups => [:development, :test]

group :production do
  # gems specifically for Heroku go here
  gem "pg"
  gem 'dm-postgres-adapter'
end
