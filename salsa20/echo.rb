# Reference: https://www.igvita.com/2007/02/13/building-dynamic-webrick-servers-in-ruby/
require 'webrick'

class Echo < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    puts request
    response.body = "<h1>Hi, World</h1>"
    response.status = 200
  end
  def do_POST request, response
    puts request
    response.status = 200
  end
end

server = WEBrick::HTTPServer.new(:Port => 8080)
server.mount "/", Echo
trap "INT" do server.shutdown end
server.start
