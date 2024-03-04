
require_relative 'route'

class Router
  def initialize
    @routes = []
  end

  def route request
    @routes.each do |route|
      next unless route.method == request.method
      next unless route.path == request.path

      route.handler.call request

      break
    end
  end

  def get path, handler
    @routes << Route.new(method: 'get', path:, handler:)
  end
end
