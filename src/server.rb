
require_relative 'imports'


class Socket
  def puts content
    super content rescue Errno::EPIPE
  end
end


router = Router.new
router.get '/', Controller::WEB.method(:index)
router.get '/static/:static_file', Controller::WEB.method(:serve_static_file)

router.get '/api/v1/tests', Controller::API::V1.method(:tests)
router.post '/api/v1/upload', Controller::API::V1.method(:upload)

router.get '/api/v2/tests', Controller::API::V2.method(:tests)
router.get '/api/v2/tests/:token', Controller::API::V2.method(:test)
router.post '/api/v2/upload', Controller::API::V2.method(:upload)


Socket.tcp_server_loop ENV['API_PORT'] do |client|
  Thread.new {
    headers_lines = []

    while line = client.gets
      break if line.strip.empty?

      headers_lines << line
    end

    next client.close unless headers_lines.first&.chomp&.end_with? 'HTTP/1.1'

    routed = router.route Request.new(headers_lines:, client:)

    unless routed
      client.puts 'HTTP/1.1 404 NOT_FOUND'
      client.close
    end
  }
end
