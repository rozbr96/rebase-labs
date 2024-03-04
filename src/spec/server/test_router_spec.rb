
require_relative '../../server/router.rb'

describe Router do
  describe '#get, #post' do
    it 'adds the route to the routes list with the right method´' do
      router = Router.new

      router.get '/', nil
      routes = router.post '/tests', method(:puts)

      expect(routes.size).to eq 2
      expect(routes.first.method).to eq 'get'
      expect(routes.first.path).to eq '/'
      expect(routes.first.handler).to be_nil

      expect(routes.last.method).to eq 'post'
      expect(routes.last.path).to eq '/tests'
      expect(routes.last.handler).to eq method(:puts)
    end
  end

  describe '#route' do
    it 'calls the right handler' do
      request_text = File.open(File.join(File.absolute_path('.'), 'spec', 'server', 'request_text.txt')).read

      request = Request.new request_text:, client: nil

      spy_object = spy(10, :to_s => true, :methods => true)

      router = Router.new
      router.post '/users', spy_object.method(:methods)
      router.get '/users', spy_object.method(:to_s)
      router.route request

      expect(spy_object).not_to have_received :methods
      expect(spy_object).to have_received :to_s
    end
  end
end