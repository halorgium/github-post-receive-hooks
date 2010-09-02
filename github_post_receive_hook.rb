#!/usr/bin/env ruby

require 'net/http'
require 'net/https'

require 'nokogiri'
require 'ruby-debug'

require 'config'

raise "No user specified" if @user.nil? || @user.empty?
raise "No token specified" if @token.nil? || @token.empty?
raise "No repo specified" if @repo.nil? || @repo.empty?
raise "No urls specified" if @urls.nil? || @urls.empty?

auth = {:login => @user, :token => @token}

def fetch(uri, req)
  server = Net::HTTP.new uri.host, uri.port
  server.use_ssl = uri.scheme == 'https'
  server.verify_mode = OpenSSL::SSL::VERIFY_NONE
  server.start {|http| http.request(req) }
end

admin_page = "https://github.com/#{@repo}/edit"
uri = URI.parse(admin_page)
req = Net::HTTP::Get.new(uri.path)
req.set_form_data(auth, '&')

res = fetch(uri, req)

doc = Nokogiri::HTML(res.body)
form = doc.at("form[action='/#{@repo}/edit/postreceive_urls']")
urls = form.search("input[name='urls[]']").map {|x| x["value"]}.compact

puts "Current: "
puts urls

urls += @urls
urls.uniq!

puts "New: "
puts urls


uri = URI.parse "#{admin_page}/postreceive_urls"
req = Net::HTTP::Post.new(uri.path)
data = auth.to_a
urls.each do |url|
  data << ["urls[]", url]
end

req.set_form_data(data, '&')

fetch(uri, req)
