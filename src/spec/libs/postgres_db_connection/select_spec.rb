
describe PGConnection do
  context '.execute' do
    context 'SELECT' do
      it 'without existing data' do
        command_output, _ = PGConnection.execute %(
          SELECT *
          FROM exam
        )

        match = command_output.match PG_OUTPUT_REGEXES::SELECT::SUCCESS
        expect(match.named_captures['rows_count']).to eq '0'
      end

      it 'with some existing data' do
        csv_raw_data = read_file_from_support 'tests_data.csv'
        Importer.new(csv_raw_data:).prepare_data.save_all

        command_output, _ = PGConnection.execute %(
          SELECT name, crm, state
          FROM doctor
        )

        match = command_output.match PG_OUTPUT_REGEXES::SELECT::SUCCESS
        expect(match.named_captures['rows_count']).to eq '1'
        expect(command_output.lines[0]).to match 'name | crm | state'
        expect(command_output.lines[2]).to match 'Maria Luiza Pires | B000BJ20J4 | PI'
      end

      it 'with non existent columns' do
        command_output, error_output = PGConnection.execute %(
          SELECT nome, crm, estado
          FROM doctor
        )

        match = error_output.match PG_OUTPUT_REGEXES::SELECT::Errors::NON_EXISTENT_COLUM

        expect(command_output).to be_empty
        expect(match.named_captures['column']).to eq 'nome'
      end
    end
  end
end
