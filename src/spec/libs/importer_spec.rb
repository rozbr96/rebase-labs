
require_relative '../../libs/importer'

describe Importer do
  describe 'initialize' do
    it 'fails if no data is given' do
      expect {
        Importer.new
      }.to raise_exception ArgumentError
    end

    it 'sets initial data accordingly' do
      app_dir = File.absolute_path '.'
      filepath = File.join app_dir, 'spec', 'libs', 'tests_data.csv'
      csv_data = File.read filepath

      importer = Importer.new csv_filepath: filepath

      expect(importer.doctors).to eq []
      expect(importer.exams).to eq []
      expect(importer.exam_types).to eq []
      expect(importer.patients).to eq []
      expect(importer.rows.count).to eq 2
      expect(importer.rows.first.count).to eq importer.columns.count
      expect(importer.columns).to eq [
        'cpf', 'nome paciente', 'email paciente',
        'data nascimento paciente', 'endereço/rua paciente',
        'cidade paciente', 'estado patiente', 'crm médico',
        'crm médico estado', 'nome médico', 'email médico',
        'token resultado exame', 'data exame', 'tipo exame',
        'limites tipo exame', 'resultado tipo exame'
      ]
    end
  end

  describe '#prepare_data' do
    it 'populates the data correctly' do
      app_dir = File.absolute_path '.'
      filepath = File.join app_dir, 'spec', 'libs', 'tests_data.csv'
      csv_data = File.read filepath

      importer = Importer.new csv_raw_data: csv_data
      importer.prepare_data

      expect(importer.doctors.count).to eq 1
      expect(importer.patients.count).to eq 1
      expect(importer.exam_types.count).to eq 2
      expect(importer.exams.count).to eq 2

      doctor = importer.doctors.first
      expect(doctor[:name]).to eq 'Maria Luiza Pires'
      expect(doctor[:crm]).to eq 'B000BJ20J4'
      expect(doctor[:state]).to eq 'PI'
      expect(doctor[:email]).to eq 'denna@wisozk.biz'

      patient = importer.patients.first
      expect(patient[:citizen_id_number]).to eq '048.973.170-88'
      expect(patient[:name]).to eq 'Emilly Batista Neto'
      expect(patient[:email]).to eq 'gerald.crona@ebert-quigley.com'
      expect(patient[:birth_date]).to eq '2001-03-11'
      expect(patient[:street_address]).to eq '165 Rua Rafaela'
      expect(patient[:city]).to eq 'Ituverava'
      expect(patient[:state]).to eq 'Alagoas'

      first_exam_type = importer.exam_types.first
      expect(first_exam_type[:name]).to eq 'hemácias'
      expect(first_exam_type[:limits]).to eq '45-52'

      second_exam = importer.exams.last
      expect(second_exam[:result]).to eq '89'
      expect(second_exam[:date]).to eq '2021-08-05'
      expect(second_exam[:token_result]).to eq 'IQCZ17'
    end
  end
end
