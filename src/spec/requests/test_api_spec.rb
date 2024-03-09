
require 'json'
require 'net/http'

require_relative '../../libs/importer'


describe 'API' do
  context 'GET /tests' do
    it 'success with empty results' do
      uri = URI "http://localhost:#{ENV['API_PORT']}/tests"
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

      uri = URI "http://localhost:#{ENV['API_PORT']}/tests"
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
end
