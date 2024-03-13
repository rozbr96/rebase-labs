
describe 'User visits the home page', type: :feature do
  context 'with the legacy flag' do
    it 'and uploads a file succesfully' do
      visit root_url params: { mode: 'legacy' }

      within '#upload-form' do
        attach_file get_filepath_for 'tests_data.csv' do
          page.find('#file-upload-label').click
        end

        click_on 'Enviar'
      end

      expect(page).to have_content 'Upload realizado com sucesso!'
      expect(page).not_to have_content 'Nenhum registro para ser exibido!'
    end

    it 'and uploads a file succesfully, without erasing the previous data' do
      csv_filepath = get_filepath_for 'tests_data.csv'
      Importer.new(csv_filepath:).prepare_data.save_all

      visit root_url params: { mode: 'legacy' }

      within '#upload-form' do
        page.find('label[data-value="unchecked"]').click

        attach_file get_filepath_for 'tests_data.csv' do
          page.find('#file-upload-label').click
        end

        click_on 'Enviar'
      end

      expect(page).to have_content 'Upload realizado com sucesso!'
      expect(page).not_to have_content 'Nenhum registro para ser exibido!'
      expect(page.all('tbody > tr').count).to eq 4
    end

    it 'and uploads a file succesfully, erasing the previous data' do
      csv_filepath = get_filepath_for 'tests_data.csv'
      Importer.new(csv_filepath:).prepare_data.save_all

      visit root_url params: { mode: 'legacy' }

      within '#upload-form' do
        page.find('label[data-value="checked"]').click

        attach_file get_filepath_for 'tests_data.csv' do
          page.find('#file-upload-label').click
        end

        click_on 'Enviar'
      end

      expect(page).to have_content 'Upload realizado com sucesso!'
      expect(page).not_to have_content 'Nenhum registro para ser exibido!'
      expect(page.all('tbody > tr').count).to eq 2
    end
  end

  it 'and tries to upload without a file being attached' do
    visit root_url

    within '#upload-form' do
      accept_alert 'É necessário selecionar um arquivo para o upload' do
        click_on 'Enviar'
      end
    end
  end
end
