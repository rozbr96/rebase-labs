
require_relative '../../server/request.rb'

describe Request do
  describe 'initialize' do
    context 'parsed values' do
      it 'parses the requests values succesfully' do
        request_text = read_file_from_support 'request_text.txt'

        request = Request.new request_text:, client: nil

        expect(request.method).to eq 'get'

        expect(request.path).to eq '/users'

        expect(request.headers['accept-encoding']).to eq 'gzip,deflate'
        expect(request.headers['host']).to eq 'www.herongyang.com'
        expect(request.headers['connection']).to eq 'Keep-Alive'
        expect(request.headers['user-agent']).to eq 'Apache-HttpClient/4.1.1 (java 1.5)'
        expect(request.headers['content-type']).to eq 'application/json'

        expect(request.data['age']).to eq 42
        expect(request.data['gender']).to eq 'F'
        expect(request.data['height_in_cm']).to eq 169
      end
    end
  end
end
