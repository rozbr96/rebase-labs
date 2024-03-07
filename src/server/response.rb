

class Response
  MESSAGES = {
    :ok => '200 OK',
  }

  CONTENT_TYPES = {
    :js => 'application/javascript',
    :css => 'text/css',
  }

  def initialize client
    @client = client
  end

  def json data:, status:
    @client.puts "HTTP/1.1 #{MESSAGES[status]}"
    @client.puts 'Content-type: application/json'
    @client.puts ''
    @client.puts data.to_json
    @client.close
  end

  def render view
    view_path = File.join File.absolute_path('.'), 'views', "#{view}.html"
    html = File.read view_path

    @client.puts 'HTTP/1.1 200 OK'
    @client.puts 'Content-type: text/html'
    @client.puts ''
    @client.puts html
    @client.close
  end

  def serve static_file
    file_extension = static_file.split('.').last.to_sym
    static_file_path = File.join File.absolute_path('.'), 'public', static_file

    data = File.read static_file_path

    @client.puts 'HTTP/1.1 200 OK'
    @client.puts "Content-type: #{CONTENT_TYPES[file_extension]}"
    @client.puts ''
    @client.puts data
    @client.close
  end
end
