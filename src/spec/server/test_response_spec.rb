
require_relative '../../server//response'

describe Response do
  describe '#json' do
    it 'sends the response with the necessary headers' do
      client = TCPSocket.new '127.0.0.1', 10000
      client_spy = spy client

      response = Response.new client_spy
      response.json data: [], status: :ok

      expect(client_spy).to have_received(:puts).with 'HTTP/1.1 200 OK'
      expect(client_spy).to have_received(:puts).with 'Content-type: application/json'
      expect(client_spy).to have_received(:puts).with ''
      expect(client_spy).to have_received(:close)
    end
  end

  describe '#render' do
    it 'sends the response with the necessary headers' do
      allow(File).to receive(:read).and_return('<h1>Hello, world!</h1>')

      client = TCPSocket.new '127.0.0.1', 10000
      client_spy = spy client

      response = Response.new client_spy
      response.render 'html_to_be_rendered'

      expect(client_spy).to have_received(:puts).with 'HTTP/1.1 200 OK'
      expect(client_spy).to have_received(:puts).with 'Content-type: text/html'
      expect(client_spy).to have_received(:puts).with ''
      expect(client_spy).to have_received(:puts).with '<h1>Hello, world!</h1>'
      expect(client_spy).to have_received(:close)
    end
  end

  describe '#serve' do
    it 'sends the response with the necessary headers' do
      allow(File).to receive(:read).and_return('<script>console.log("Loaded after the initial request")</script>')

      client = TCPSocket.new '127.0.0.1', 10000
      client_spy = spy client

      response = Response.new client_spy
      response.serve 'index.js'

      expect(client_spy).to have_received(:puts).with 'HTTP/1.1 200 OK'
      expect(client_spy).to have_received(:puts).with 'Content-type: application/javascript'
      expect(client_spy).to have_received(:puts).with ''
      expect(client_spy).to have_received(:puts).with '<script>console.log("Loaded after the initial request")</script>'
      expect(client_spy).to have_received(:close)
    end
  end
end
