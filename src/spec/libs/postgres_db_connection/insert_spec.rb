
describe PGConnection do
  context '.execute' do
    context 'INSERT' do
      it 'single row with valid data' do
        command_output, _ = PGConnection.execute %(
          INSERT INTO exam_type (name, limits)
          VALUES ('leucócitos', '9-61')
        )

        match = command_output.match PG_OUTPUT_REGEXES::INSERT::SUCCESS
        expect(match.named_captures['rows_count']).to eq '1'
      end

      it 'multiple row with valid data' do
        command_output, _ = PGConnection.execute %(
          INSERT INTO exam_type (name, limits)
          VALUES ('leucócitos', '9-61'),
            ('hemácias', '45-52')
        )

        match = command_output.match PG_OUTPUT_REGEXES::INSERT::SUCCESS
        expect(match.named_captures['rows_count']).to eq '2'
      end

      it 'with duplicated data' do
        csv_raw_data = read_file_from_support 'tests_data.csv'
        Importer.new(csv_raw_data:).prepare_data.save_all

        command_output, command_error = PGConnection.execute %(
          INSERT INTO exam_type (name, limits)
          VALUES ('leucócitos', '9-61')
        )

        match = command_error.match PG_OUTPUT_REGEXES::INSERT::Errors::DUPLICATE_KEY_VALUE_DETAIL

        expect(command_output).to be_empty
        expect(command_error).to match PG_OUTPUT_REGEXES::INSERT::Errors::DUPLICATE_KEY_VALUE
        expect(match.named_captures['column']).to eq 'name'
        expect(match.named_captures['value']).to eq 'leucócitos'
      end

      it 'with non existent columns' do
        command_output, command_error = PGConnection.execute %(
          INSERT INTO exam_type (nome, limites)
          VALUES ('leucócitos', '9-61')
        )

        match = command_error.match PG_OUTPUT_REGEXES::INSERT::Errors::NON_EXISTENT_COLUM

        expect(command_output).to be_empty
        expect(match.named_captures['column']).to eq 'nome'
      end
    end
  end
end
