
describe 'API V2 GET /tests/:token' do
  it 'returns data succesfully' do
    csv_data = read_file_from_support 'tests_data.csv'
    importer = Importer.new csv_raw_data: csv_data
    importer.prepare_data.save_all

    uri = URI api_v2_test_url 'iqcz17'
    response = Net::HTTP.get_response uri

    expect(response.code).to eq '200'
    expect(response.content_type).to eq 'application/json'

    json_response = JSON.parse response.body

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

    uri = URI api_v2_test_url 'NON_EXISTENT_TOKEN'
    response = Net::HTTP.get_response uri

    expect(response.code).to eq '404'
  end
end
