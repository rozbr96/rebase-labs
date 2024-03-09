
require_relative '../../libs/data_extractor'

describe DataExtractor do
  before :all do
    @columns = [
      'cpf', 'nome paciente', 'email paciente',
      'data nascimento paciente', 'endereço/rua paciente',
      'cidade paciente', 'estado patiente', 'crm médico',
      'crm médico estado', 'nome médico', 'email médico',
      'token resultado exame', 'data exame', 'tipo exame',
      'limites tipo exame', 'resultado tipo exame'
    ]

    @values = [
      '048.973.170-88', 'Emilly Batista Neto', 'gerald.crona@ebert-quigley.com',
      '2001-03-11', '165 Rua Rafaela', 'Ituverava', 'Alagoas', 'B000BJ20J4',
      'PI', 'Maria Luiza Pires', 'denna@wisozk.biz', 'IQCZ17', '2021-08-05',
      'hemácias', '45-52', '97'
    ]
  end

  describe '.get_row_data' do
    it 'maps the data correctly' do
      row_data = DataExtractor.get_row_data @columns, @values

      expect(row_data['cpf']).to eq '048.973.170-88'
      expect(row_data['nome paciente']).to eq 'Emilly Batista Neto'
      expect(row_data['email paciente']).to eq 'gerald.crona@ebert-quigley.com'
      expect(row_data['crm médico estado']).to eq 'PI'
      expect(row_data['resultado tipo exame']).to eq '97'
    end
  end

  context 'data extraction' do
    it '.get_doctor_data' do
      row_data = DataExtractor.get_row_data @columns, @values
      doctor_data = DataExtractor.get_doctor_data row_data

      expect(doctor_data[:name]).to eq 'Maria Luiza Pires'
      expect(doctor_data[:email]).to eq 'denna@wisozk.biz'
      expect(doctor_data[:crm]).to eq 'B000BJ20J4'
      expect(doctor_data[:state]).to eq 'PI'
    end

    it '.get_exam_data' do
      row_data = DataExtractor.get_row_data @columns, @values
      exam_data = DataExtractor.get_exam_data row_data

      expect(exam_data[:date]).to eq '2021-08-05'
      expect(exam_data[:result]).to eq '97'
      expect(exam_data[:token_result]).to eq 'IQCZ17'
      expect(exam_data[:citizen_id_number]).to eq '048.973.170-88'
      expect(exam_data[:state]).to eq 'PI'
      expect(exam_data[:crm]).to eq 'B000BJ20J4'
      expect(exam_data[:name]).to eq 'hemácias'
    end

    it '.get_exam_type_data' do
      row_data = DataExtractor.get_row_data @columns, @values
      exam_type_data = DataExtractor.get_exam_type_data row_data

      expect(exam_type_data[:name]).to eq 'hemácias'
      expect(exam_type_data[:limits]).to eq '45-52'
    end

    it '.get_patient_data' do
      row_data = DataExtractor.get_row_data @columns, @values
      patient_data = DataExtractor.get_patient_data row_data

      expect(patient_data[:citizen_id_number]).to eq '048.973.170-88'
      expect(patient_data[:name]).to eq 'Emilly Batista Neto'
      expect(patient_data[:email]).to eq 'gerald.crona@ebert-quigley.com'
      expect(patient_data[:birth_date]).to eq '2001-03-11'
      expect(patient_data[:street_address]).to eq '165 Rua Rafaela'
      expect(patient_data[:city]).to eq 'Ituverava'
      expect(patient_data[:state]).to eq 'Alagoas'
    end
  end
end
