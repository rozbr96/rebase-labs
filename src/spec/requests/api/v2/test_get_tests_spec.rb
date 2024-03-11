
describe 'API V2 GET /tests' do
  it 'succeeds with empty results' do
    uri = URI api_v2_tests_url
    response = Net::HTTP.get_response uri

    expect(response.code).to eq '200'
    expect(response.content_type).to eq 'application/json'

    json_response = JSON.parse response.body

    expect(json_response.count).to eq 0
  end

  it 'succeeds with some results' do
    filepath = get_filepath_for 'tests_data.csv'
    importer = Importer.new csv_filepath: filepath
    importer.prepare_data.save_all

    uri = URI api_v2_tests_url
    response = Net::HTTP.get_response uri

    expect(response.code).to eq '200'
    expect(response.content_type).to eq 'application/json'

    json_response = JSON.parse response.body
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
