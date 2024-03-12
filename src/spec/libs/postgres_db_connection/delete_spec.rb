
describe PGConnection do
  context '.execute' do
    context 'DELETE' do
      it 'single row' do
        csv_filepath = get_filepath_for 'tests_data.csv'
        Importer.new(csv_filepath:).prepare_data.save_all

        exam_id = PGConnection.execute(%(
          SELECT id
          FROM exam
          LIMIT 1
        )).first.lines[2].strip

        command_output, _ = PGConnection.execute %(
          DELETE FROM exam
          WHERE id = #{exam_id}
        )

        match = command_output.match PG_OUTPUT_REGEXES::DELETE::SUCCESS

        expect(match.named_captures['rows_count']).to eq '1'
      end

      it 'multiple rows' do
        csv_filepath = get_filepath_for 'tests_data.csv'
        Importer.new(csv_filepath:).prepare_data.save_all

        command_output, _ = PGConnection.execute %(
          DELETE FROM exam
        )

        match = command_output.match PG_OUTPUT_REGEXES::DELETE::SUCCESS

        expect(match.named_captures['rows_count']).to eq '2'
      end

      it 'no rows' do
        csv_filepath = get_filepath_for 'tests_data.csv'
        Importer.new(csv_filepath:).prepare_data.save_all

        command_output, _ = PGConnection.execute %(
          DELETE FROM exam
          WHERE id = 0
        )

        match = command_output.match PG_OUTPUT_REGEXES::DELETE::SUCCESS

        expect(match.named_captures['rows_count']).to eq '0'
      end

      it 'with invalid columns' do
        command_output, error_output = PGConnection.execute %(
          DELETE FROM exam
          WHERE nome = 'leucócitos'
        )

        match = error_output.match PG_OUTPUT_REGEXES::DELETE::Errors::NON_EXISTENT_COLUM

        expect(command_output).to eq ''
        expect(match.named_captures['column']).to eq 'nome'
      end
    end
  end
end
