
class Router
  def initialize
    @routes = []
  end

  def route request
    response = Response.new request.client

    @routes.each do |route|
      next unless route.method == request.method
      next unless route.path.match? request.path

      request.set_params route.path.match request.path

      route.handler.call request, response

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
