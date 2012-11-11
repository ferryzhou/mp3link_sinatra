require 'rubygems'
require 'sinatra'
require './mp3link'

require 'data_mapper'

#################
# Configuration #
#################

class Mp3link
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :link, Text
    property :created_at, DateTime
end

configure :production do
  p 'production .......'
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
end

configure :development do
  p 'development ........'
#  DataMapper.setup(:default, 'sqlite3://mp3links.sqlite3')
  DataMapper.setup(:default, 'sqlite::memory:')
end
DataMapper.finalize

Mp3link.auto_upgrade!

get '/hello' do
  "Hello World!"
end

get '/q' do
  obj = Mp3link.first(:name => params[:name])
  p "from database: #{obj}"
  if obj.nil?
    p 'not found in database'
    link = query_mp3(utf8_to_gb2312(params[:name]))
    Mp3link.create(:name => params[:name], :link => link, :created_at => Time.now )
    link
  else
    obj.link
  end
end

get '/rq' do
  query_mp3(utf8_to_gb2312(params[:name]))
end

