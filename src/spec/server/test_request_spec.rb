
describe Request do
  describe 'initialize' do
    context 'parsed values' do
      it 'parses the requests values succesfully' do
        headers_text = read_file_from_support 'simple_request/headers.txt'
        body_text = read_file_from_support 'simple_request/body.txt'

        client, helper = IO.pipe
        helper.puts body_text

        request = Request.new client:, headers_lines: headers_text.lines

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

      it 'parses multipart forms successfully' do
        csv_raw_data = read_file_from_support 'tests_data.csv'
        headers_text = read_file_from_support 'upload_request/headers.txt'
        body_text = read_file_from_support 'upload_request/body.txt'

        client, helper = IO.pipe
        helper.puts body_text

        request = Request.new client:, headers_lines: headers_text.lines

        expect(request.method).to eq 'post'
        expect(request.path).to eq '/upload'

        expect(request.headers['content-length']).to eq '1208'
        expect(request.headers['content-type']).to match 'multipart/form-data'

        expect(request.file).not_to be_nil
        expect(request.file.path).to match 'tests_data.csv'
        expect(request.file.read).to eq csv_raw_data

        expect(request.data.kind_of? Hash).to be true
        expect(request.data['fields']).to eq ['cpf', 'nome paciente']
        expect(request.data['count']).to eq [2]
        expect(request.data['overwrite']).to eq [true]
      end
    end
  end
end
