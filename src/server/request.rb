
require 'json'

class Request
  attr_reader :method, :path, :version, :headers, :data, :client

  def initialize request_text:, client:
    @client = client

    headers_text, body_text = request_text.split "\r\n\r\n"
    headers_text = headers_text.split "\r\n"

    @method, @path, @version = headers_text.shift.split
    @method.downcase!

    @headers = headers_text.reduce({}) do |headers, line|
      key, value = line.split ': '
      headers.update key => value
    end

    @data = case @headers['content-type']
    when 'application/json'
      JSON.parse(%(#{body_text}))
    else
      body_text
    end
  end
end
