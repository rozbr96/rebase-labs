
require 'json'

class Request
  attr_reader :method, :path, :headers, :data, :client, :params

  def initialize request_text:, client:
    @params = {}
    @client = client

    headers_text, body_text = request_text.split /\r?\n\r?\n/
    headers_text = headers_text.split /\r?\n/

    @method, @path, _ = headers_text.shift.split
    @method.downcase!

    @headers = headers_text.reduce({}) do |headers, line|
      key, value = line.split ': '
      headers.update key.downcase => value
    end

    @data = case @headers['content-type']
    when 'application/json'
      JSON.parse(%(#{body_text}))
    else
      body_text
    end
  end

  def set_params match_data
    return if match_data.nil?

    @params = match_data.named_captures
  end
end
