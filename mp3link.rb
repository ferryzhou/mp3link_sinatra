# encoding: UTF-8

require 'open-uri'
require 'net/http'
require 'uri'
require 'iconv'
require 'hpricot'

# use sougou mp3 search
# return a set of mp3 links
# 
# http://mp3.sogou.com/music.so?query=<names>
# example:
# 对不起我爱你 梁静茹
# http://mp3.sogou.com/music.so?query=%B6%D4%B2%BB%C6%F0%CE%D2%B0%AE%C4%E3+%C1%BA%BE%B2%C8%E3
#
# in main result page, find a.link
#   extract onclick, then window.open
#   get the page, get table.linkbox//a href
def query_mp3(str)
  query_str = "http://mp3.sogou.com/music.so?query=" + URI.escape(str)
  #query_str = 'http://mp3.sogou.com/music.so?query=%B6%D4%B2%BB%C6%F0%CE%D2%B0%AE%C4%E3+%C1%BA%BE%B2%C8%E3'
  p query_str
  main_links = extract_main_page_links(query_str)
  main_links.each do |mlink| 
     mp3_link = get_sublink(mlink)
     return mp3_link if not mp3_link.nil? or mp3.link.empty?
  end
end

def get_content(url)
  source = open(url)
  content = source.respond_to?(:read) ? source.read : source.to_s
end

def utf8_to_gb2312(str); Iconv.iconv('GBK', 'utf-8', str).join; end

def extract_main_page_links(url)
  doc = open(url) { |f| Hpricot(f) }
  elements = doc.search("a.link")
  puts "#{elements.size} results:"
  elements.collect do |e|
    onclick = e['onclick']
	p "#{onclick}"
	next if onclick.nil? or onclick.empty?
	s_ind = 'window.open('.length
	e_ind = onclick.index('\',')
	onclick[s_ind+1...e_ind]
  end  
end

def get_sublink(mlink)
  slink = "http://mp3.sogou.com#{mlink}"
  p "get sublink #{slink} ..."
  extract_second_page_link(slink)
end

def extract_second_page_link(url)
  doc = open(url) { |f| Hpricot(f) }
  element = doc.at("table.linkbox//a")
  element['href']
end

