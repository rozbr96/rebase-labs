
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
    add_route 'get', path, handler
  end

  def post path, handler
    add_route 'post', path, handler
  end

  private

  def add_route method, path, handler
    @routes << Route.new(method:, path:, handler:)
  end
end
