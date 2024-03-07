
describe 'User visits the home page', type: :feature do
  it 'and sees the existing exams' do
    visit 'http://127.0.0.1:10000'

    expect(page).to have_content 'Lista de Exames Médicos'
  end
end
