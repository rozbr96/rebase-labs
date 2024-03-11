
require 'json'
require 'tempfile'

class Request
  attr_reader :method, :path, :headers, :data, :client, :params, :file

  def initialize request_text:, client:
    @params = {}
    @client = client

    headers_text, body_text = request_text.split(/\r?\n\r?\n/, 2)
    headers_text = headers_text.split(/\r?\n/)

    @method, @path, _ = headers_text.shift.split
    @method.downcase!

    @headers = parsed_headers headers_text

    case @headers['content-type']
    when /application\/json/
      @data = JSON.parse(%(#{body_text}))
    when /multipart\/form-data/
      parse_multipart_data body_text, @headers['content-type']
    else
      @data = body_text
    end
  end

  def set_params match_data
    return if match_data.nil?

    @params = match_data.named_captures
  end

  private

  def parsed_headers headers_text
    headers_text = headers_text.strip.split(/\r?\n/) if headers_text.kind_of? String
    headers_text.reduce({}) do |headers, line|
      key, value = line.split ': ', 2
      headers.update key.downcase => value
    end
  end

  def parse_multipart_data multipart_data_text, content_type
    @data = Hash.new { |hash, key| hash[key] = [] }

    boundary = /boundary=(.*)(;|$)/.match(content_type).captures.first
    boundary = "--#{boundary}"

    regex = Regexp.new "#{boundary}(.*)#{boundary}--", Regexp::MULTILINE

    multipart_part_parts = multipart_data_text.match(regex).captures.first.split boundary
    multipart_part_parts.each do |multipart_part|
      headers, content = multipart_part.split(/\r?\n\r?\n/, 2)

      headers = parsed_headers headers
      content = content.strip

      disposition = headers['content-disposition']
      if headers['content-type']
        filename = disposition.match(/filename="(.*)"($|;)/).captures.first
        @file = Tempfile.new filename
        @file.write content
        @file.rewind
      else
        varname = disposition.match(/name="(.*)"($|;)/).captures.first

        value = begin
          JSON.parse content
        rescue
          content
        end

        @data[varname] << value
      end
    end
  end
end
