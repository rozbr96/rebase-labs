
require_relative '../../../libs/importer.rb'

describe 'User visits the home page', type: :feature do
  it 'and sees no existing exams' do
    visit root_url

    expect(page).to have_content 'Lista de Exames Médicos'
    expect(page).to have_selector 'td[colspan="11"]'
    expect(page).to have_content 'Nenhum registro para ser exibido!'
  end

  it 'and sees existing exams' do
    csv_raw_data = read_file_from_support 'tests_data.csv'
    Importer.new(csv_raw_data:).prepare_data.save_all

    visit root_url

    expect(page).not_to have_selector 'td[colspan="11"]'
    expect(page).not_to have_content 'Nenhum registro para ser exibido!'
    expect(page).to have_selector 'td[rowspan="2"]'
    expect(page).to have_content '048.973.170-88'
    expect(page).to have_content 'Emilly Batista Neto'
    expect(page).to have_content 'Maria Luiza Pires'
    expect(page).to have_content '11/03/2001'
    expect(page).to have_content '05/08/2021'
    expect(page).to have_content 'hemácias'
    expect(page).to have_content 'leucócitos'
    expect(page).to have_content '45-52'
    expect(page).to have_content '9-61'
  end
end
