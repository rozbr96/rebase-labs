
describe Router do
  describe '#get, #post' do
    it 'adds the route to the routes list with the right method´' do
      router = Router.new

      router.get '/', nil
      routes = router.post '/tests', method(:puts)

      expect(routes.size).to eq 2
      expect(routes.first.method).to eq 'get'
      expect(routes.first.path).to match '/'
      expect(routes.first.handler).to be_nil

      expect(routes.last.method).to eq 'post'
      expect(routes.last.path).to match '/tests'
      expect(routes.last.handler).to eq method(:puts)
    end
  end

  describe '#route' do
    it 'calls the right handler' do
      request_text = read_file_from_support 'simple_request/headers.txt'
      body_text = read_file_from_support 'simple_request/body.txt'

      client, helper = IO.pipe
      helper.puts body_text

      request = Request.new client:, headers_lines: request_text.lines

      spy_object = spy(10, :to_s => true, :methods => true)

      router = Router.new
      router.post '/users', spy_object.method(:methods)
      router.get '/users', spy_object.method(:to_s)
      routed = router.route request

      expect(routed).to eq true
      expect(spy_object).not_to have_received :methods
      expect(spy_object).to have_received :to_s
    end

    it 'calls the right handler with named parameters' do
      request_text = read_file_from_support 'request_with_mult_levels_text.txt'
      request = Request.new headers_lines: request_text.lines, client: nil

      spy_object = spy(10, :to_s => true, :methods => true)

      router = Router.new
      router.post '/users/:user_id/posts', spy_object.method(:methods)
      router.get '/users/:user_id/posts/:post_id', spy_object.method(:to_s)
      routed = router.route request

      expect(routed).to eq true
      expect(request.params['user_id']).to eq '10'
      expect(request.params['post_id']).to eq '3'
      expect(spy_object).not_to have_received :methods
      expect(spy_object).to have_received :to_s
    end

    it 'returns false cause no path was matched' do
      request_text = read_file_from_support 'request_with_mult_levels_text.txt'
      request = Request.new headers_lines: request_text.lines, client: nil

      router = Router.new
      routed = router.route request

      expect(routed).to eq false
    end
  end
end
