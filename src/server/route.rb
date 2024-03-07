
class Route
  attr_reader :method, :path, :handler

  def initialize method:, path:, handler:
    @method = method

    path.gsub!(/:(\w+)/, '(?<\1>.+)')

    @path = Regexp.new "^#{path}$"
    @handler = handler
  end
end
