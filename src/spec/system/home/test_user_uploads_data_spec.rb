
describe 'User visits the home page', type: :feature do
  it 'and uploads a file succesfully' do
    visit root_url

    within '#upload-form' do
      attach_file get_filepath_for 'tests_data.csv' do
        page.find('#file-upload-label').click
      end

      click_on 'Enviar'
    end

    expect(page).to have_content 'Upload realizado com sucesso!'
    expect(page).not_to have_content 'Nenhum registro para ser exibido!'
  end
end
