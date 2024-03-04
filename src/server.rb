
require 'socket'
require_relative 'server/router.rb'
require_relative 'server/request.rb'
require_relative 'server/controller.rb'


router = Router.new
router.get '/tests', Controller.method(:tests)


Socket.tcp_server_loop ENV['API_PORT'] do |client|
  request_text = client.recvmsg.first

  unless request_text.lines.first.end_with? 'HTTP/1.1'
    client.close
    next
  end

  router.route Request.new request_text:, client:
end
