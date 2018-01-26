# Reference: https://www.igvita.com/2007/02/13/building-dynamic-webrick-servers-in-ruby/
require 'webrick'
require './salsa.rb'

module WEBrick

  class HTTPResponse

    def send_header(socket) # :nodoc:
      @salsa = Salsa20.new [0, 1, 2, 3], 20
      if @http_version.major > 0
        data = status_line()
        @header.each{|key, value|
          tmp = key.gsub(/\bwww|^te$|\b\w/){ $&.upcase }
          data << "#{tmp}: #{value}" << CRLF
        }
        @cookies.each{|cookie|
          data << "Set-Cookie: " << cookie.to_s << CRLF
        }
        data << CRLF
        _write_data(socket, @salsa.encript_str( data))
      end

      def send_body_io(socket)
        begin
          if @request_method == "HEAD"
            # do nothing
          elsif chunked?
            begin
              buf  = ''
              data = ''
              while true
                @body.readpartial( @buffer_size, buf ) # there is no need to clear buf?
                data << format("%x", buf.bytesize) << CRLF
                data << buf << CRLF
                _write_data(socket, data)
                data.clear
                @sent_size += buf.bytesize
              end
            rescue EOFError # do nothing
            end
            _write_data(socket, "0#{CRLF}#{CRLF}")
          else
            size = @header['content-length'].to_i
            _send_file(socket, @body, 0, size)
            @sent_size = size
          end
        ensure
          @body.close
        end
      end

      def send_body_string(socket)
        if @request_method == "HEAD"
          # do nothing
        elsif chunked?
          body ? @body.bytesize : 0
          while buf = @body[@sent_size, @buffer_size]
            break if buf.empty?
            data = ""
            data << format("%x", buf.bytesize) << CRLF
            data << buf << CRLF
            _write_data(socket, data)
            @sent_size += buf.bytesize
          end
          _write_data(socket, "0#{CRLF}#{CRLF}")
        else
          if @body && @body.bytesize > 0
            _write_data(socket, @salsa.encript_str(@body))
            @sent_size = @body.bytesize
          end
        end
  end
end
  end

  def foo
  end
end

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
p server.methods
server.mount "/", Echo
trap "INT" do server.shutdown end
server.start
# server.run
