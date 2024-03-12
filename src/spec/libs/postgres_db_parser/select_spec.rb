
describe PGParser do
  context '.parse_select_output' do
    context 'success' do
      it 'parses simple select output correctly' do
        csv_filepath = get_filepath_for 'tests_data.csv'
        Importer.new(csv_filepath:).prepare_data.save_all

        command_output, _ = PGConnection.execute %(
          SELECT name, crm
          FROM doctor
        )

        doctors = PGParser.parse_select_output command_output

        expect(doctors.count).to eq 1
        expect(doctors.first['name']).to eq 'Maria Luiza Pires'
        expect(doctors.first['crm']).to eq 'B000BJ20J4'
      end

      it 'parses select with join output correctly' do
        csv_filepath = get_filepath_for 'tests_data.csv'
        Importer.new(csv_filepath:).prepare_data.save_all

        command_output, _ = PGConnection.execute %(
          SELECT DISTINCT doctor.name doctor_name, patient.name patient_name, exam.date exam_date
          FROM exam
          JOIN patient ON exam.patient_id = patient.id
          JOIN doctor ON exam.doctor_id = doctor.id
        )

        exams = PGParser.parse_select_output command_output

        expect(exams.count).to eq 1
        expect(exams.first['doctor_name']).to eq 'Maria Luiza Pires'
        expect(exams.first['patient_name']).to eq 'Emilly Batista Neto'
        expect(exams.first['exam_date']).to eq '2021-08-05'
      end

      it 'without returned rows' do
        command_output, _ = PGConnection.execute %(
          SELECT name, crm
          FROM doctor
        )

        doctors = PGParser.parse_select_output command_output

        expect(doctors.count).to eq 0
      end
    end
  end
end
