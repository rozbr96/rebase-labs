
module Controller
  module API
    module V1
      def self.tests request, response
        exams = Exam.select(
          joins: tests_joinings,
          fields_selection: tests_fields_selection,
          offset: request.params['offset'],
          limit: request.params['limit'],
        )

        response.json data: exams, status: :ok
      end

      def self.upload request, response
        return response.json data: [], status: :bad_request if request.file.nil?

        if request.data['overwrite']&.first == true
          Exam.delete_all
          ExamType.delete_all
          Doctor.delete_all
          Patient.delete_all
        end

        importer = Importer.new csv_filepath: request.file.path
        importer.prepare_data.save_all

        response.json data: [], status: :ok
      end

      def self.tests_joinings
        {
          Doctor => %w[doctor_id id],
          Patient => %w[patient_id id],
          ExamType => %w[exam_type_id id],
        }
      end

      def self.tests_fields_selection
        {
          Exam => %w[id date result token_result],
          Doctor => %w[name email crm state],
          Patient => %w[citizen_id_number name email birth_date street_address city state],
          ExamType => %w[name limits]
        }
      end
    end
  end
end
