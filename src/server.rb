
require 'socket'
require_relative 'models'
require_relative 'server/router.rb'
require_relative 'server/request.rb'
require_relative 'server/controller.rb'


router = Router.new
router.get '/', Controller.method(:index)
router.get '/tests', Controller.method(:tests)
router.get '/static/:static_file', Controller.method(:serve_static_file)


Socket.tcp_server_loop ENV['API_PORT'] do |client|
  request_text = client.recvmsg.first


  # TODO figure out whats happening
  next if request_text.lines.first.nil?

  unless request_text.lines.first.chomp.end_with? 'HTTP/1.1'
    client.close
    next
  end

  router.route Request.new request_text:, client:
end
