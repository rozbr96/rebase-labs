
require_relative '../../../libs/importer.rb'

describe 'User visits the home page', type: :feature do
  it 'and sees no existing exams' do
    visit "http://127.0.0.1:#{ENV['API_PORT']}"

    expect(page).to have_content 'Lista de Exames Médicos'
    expect(page).to have_selector 'td[colspan="10"]'

  end

  it 'and sees existing exams' do
    csv_raw_data = read_file_from_support 'tests_data.csv'
    Importer.new(csv_raw_data:).prepare_data.save_all

    visit "http://127.0.0.1:#{ENV['API_PORT']}"

    expect(page).not_to have_selector 'td[colspan="10"]'
  end
end
