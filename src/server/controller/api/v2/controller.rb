
module Controller
  module API
    module V2
      def self.test request, response
        exam = Exam.select(
          joins: tests_joinings,
          fields_selection: tests_fields_selection,
          where: tests_where_data(request),
          version: 'V2'
        ).first

        return response.json data: exam, status: :ok unless exam.nil?

        response.json data: nil, status: :not_found
      end

      def self.tests request, response
        exams = Exam.select(
          joins: tests_joinings,
          fields_selection: tests_fields_selection,
          version: 'V2'
        )

        response.json data: exams, status: :ok
      end

      def self.tests_fields_selection
        {
          Exam => %w[id date result token_result],
          Doctor => %w[name email crm state],
          Patient => %w[citizen_id_number name email birth_date street_address city state],
          ExamType => %w[name limits],
        }
      end

      def self.tests_joinings
        {
          Doctor => %w[doctor_id id],
          Patient => %w[patient_id id],
          ExamType => %w[exam_type_id id],
        }
      end

      def self.tests_where_data request
        {
          'exam.token_result': {
            :value => request.params['token'],
            :ignore_case => true,
          },
        }
      end

      def self.upload request, response
        return response.json data: [], status: :bad_request if request.file.nil?

        response.json data: [], status: :ok

        Thread.new {
          if request.data['overwrite']&.first == true
            Exam.delete_all
            ExamType.delete_all
            Doctor.delete_all
            Patient.delete_all
          end

          importer = Importer.new csv_filepath: request.file.path
          importer.prepare_data.save_all
        }
      end
    end
  end
end
