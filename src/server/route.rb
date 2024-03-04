
class Route
  attr_reader :method, :path, :handler

  def initialize method:, path:, handler:
    @method = method
    @path = path
    @handler = handler
  end
end
