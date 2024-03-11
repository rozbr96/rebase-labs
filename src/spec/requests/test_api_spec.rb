
require 'json'
require 'net/http'

require_relative '../../libs/importer'


describe 'API' do
  context 'V1' do
    context 'GET /tests' do
      it 'success with empty results' do
        uri = URI api_v1_tests_url
        response = Net::HTTP.get_response uri

        expect(response.code).to eq '200'
        expect(response.content_type).to eq 'application/json'

        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq 0
      end

      it 'success with some results' do
        filepath = get_filepath_for 'tests_data.csv'
        importer = Importer.new csv_filepath: filepath
        importer.prepare_data.save_all

        uri = URI api_v1_tests_url
        response = Net::HTTP.get_response uri

        expect(response.code).to eq '200'
        expect(response.content_type).to eq 'application/json'

        json_response = JSON.parse(response.body)
        exam = json_response.first

        expect(json_response.count).to eq 2
        expect(exam['exam_date']).to eq '2021-08-05'
        expect(exam['exam_result']).to eq '97'
        expect(exam['exam_token_result']).to eq 'IQCZ17'
        expect(exam['doctor_name']).to eq 'Maria Luiza Pires'
        expect(exam['doctor_email']).to eq 'denna@wisozk.biz'
        expect(exam['doctor_crm']).to eq 'B000BJ20J4'
        expect(exam['doctor_state']).to eq 'PI'
        expect(exam['patient_citizen_id_number']).to eq '048.973.170-88'
        expect(exam['patient_name']).to eq 'Emilly Batista Neto'
        expect(exam['patient_email']).to eq 'gerald.crona@ebert-quigley.com'
        expect(exam['patient_birth_date']).to eq '2001-03-11'
        expect(exam['patient_street_address']).to eq '165 Rua Rafaela'
        expect(exam['patient_city']).to eq 'Ituverava'
        expect(exam['patient_state']).to eq 'Alagoas'
        expect(exam['exam_type_name']).to eq 'hemácias'
        expect(exam['exam_type_limits']).to eq '45-52'
      end
    end

    context 'POST /upload' do
      xit 'fails to update data without a file' do; end
    end
  end

  context 'V2' do
    context 'GET /tests' do
      it 'success with empty results' do
        uri = URI api_v2_tests_url
        response = Net::HTTP.get_response uri

        expect(response.code).to eq '200'
        expect(response.content_type).to eq 'application/json'

        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq 0
      end

      it 'success with some results' do
        filepath = get_filepath_for 'tests_data.csv'
        importer = Importer.new csv_filepath: filepath
        importer.prepare_data.save_all

        uri = URI api_v2_tests_url
        response = Net::HTTP.get_response uri

        expect(response.code).to eq '200'
        expect(response.content_type).to eq 'application/json'

        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq 1

        data = json_response.first

        expect(data['patient']['citizen_id_number']).to eq '048.973.170-88'
        expect(data['patient']['name']).to eq 'Emilly Batista Neto'
        expect(data['patient']['email']).to eq 'gerald.crona@ebert-quigley.com'
        expect(data['patient']['birth_date']).to eq '2001-03-11'
        expect(data['patient']['street_address']).to eq '165 Rua Rafaela'
        expect(data['patient']['city']).to eq 'Ituverava'
        expect(data['patient']['state']).to eq 'Alagoas'

        expect(data['doctor']['name']).to eq 'Maria Luiza Pires'
        expect(data['doctor']['email']).to eq 'denna@wisozk.biz'
        expect(data['doctor']['crm']).to eq 'B000BJ20J4'
        expect(data['doctor']['state']).to eq 'PI'

        expect(data['tests'].count).to eq 2

        expect(data['tests'].first['type']).to eq 'hemácias'
        expect(data['tests'].last['type']).to eq 'leucócitos'

        expect(data['tests'].first['result']).to eq '97'
        expect(data['tests'].last['result']).to eq '89'

        expect(data['tests'].first['limits']).to eq '45-52'
        expect(data['tests'].last['limits']).to eq '9-61'

        expect(data['date']).to eq '2021-08-05'
        expect(data['result_token']).to eq 'IQCZ17'
      end
    end

    context 'GET /tests/:token' do
      it 'returns data succesfully' do
        csv_data = read_file_from_support 'tests_data.csv'
        importer = Importer.new csv_raw_data: csv_data
        importer.prepare_data.save_all

        uri = URI "http://localhost:#{ENV['API_PORT']}/api/v2/tests/IQCZ17"
        response = Net::HTTP.get_response uri

        expect(response.code).to eq '200'
        expect(response.content_type).to eq 'application/json'

        json_response = JSON.parse(response.body)

        expect(json_response['patient']['citizen_id_number']).to eq '048.973.170-88'
        expect(json_response['patient']['name']).to eq 'Emilly Batista Neto'
        expect(json_response['patient']['email']).to eq 'gerald.crona@ebert-quigley.com'
        expect(json_response['patient']['birth_date']).to eq '2001-03-11'
        expect(json_response['patient']['street_address']).to eq '165 Rua Rafaela'
        expect(json_response['patient']['city']).to eq 'Ituverava'
        expect(json_response['patient']['state']).to eq 'Alagoas'

        expect(json_response['doctor']['name']).to eq 'Maria Luiza Pires'
        expect(json_response['doctor']['email']).to eq 'denna@wisozk.biz'
        expect(json_response['doctor']['crm']).to eq 'B000BJ20J4'
        expect(json_response['doctor']['state']).to eq 'PI'

        expect(json_response['tests'].count).to eq 2

        expect(json_response['tests'].first['type']).to eq 'hemácias'
        expect(json_response['tests'].last['type']).to eq 'leucócitos'

        expect(json_response['tests'].first['result']).to eq '97'
        expect(json_response['tests'].last['result']).to eq '89'

        expect(json_response['tests'].first['limits']).to eq '45-52'
        expect(json_response['tests'].last['limits']).to eq '9-61'

        expect(json_response['date']).to eq '2021-08-05'
        expect(json_response['result_token']).to eq 'IQCZ17'
      end

      it 'finds no data for the given token' do
        csv_data = read_file_from_support 'tests_data.csv'
        importer = Importer.new csv_raw_data: csv_data
        importer.prepare_data.save_all

        uri = URI "http://localhost:#{ENV['API_PORT']}/api/v2/tests/NON_EXISTENT_TOKEN"
        response = Net::HTTP.get_response uri

        expect(response.code).to eq '404'
      end
    end
  end
end
