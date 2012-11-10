require 'rubygems'
require 'sinatra'
require './mp3link'

get '/hello' do
  "Hello World!"
end

get '/q' do
  query_mp3(utf8_to_gb2312(params[:name]))
end

