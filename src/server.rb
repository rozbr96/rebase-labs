
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
router.get '/api/v2/tests', Controller::API::V2.method(:tests)
router.get '/api/v2/tests/:token', Controller::API::V2.method(:test)
router.post '/api/v1/upload', Controller::API::V1.method(:upload)


Socket.tcp_server_loop ENV['API_PORT'] do |client|
  request_text = client.recvmsg.first

  # TODO figure out whats happening
  next if request_text.lines.first.nil?

  unless request_text.lines.first.chomp.end_with? 'HTTP/1.1'
    next client.close
  end

  router.route Request.new request_text:, client:
end
