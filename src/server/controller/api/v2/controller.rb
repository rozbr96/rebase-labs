
module Controller
  module API
    module V2
      def self.test request, response
        exam = Exam.select(joins: {
            Doctor => %w[doctor_id id],
            Patient => %w[patient_id id],
            ExamType => %w[exam_type_id id],
          }, fields_selection: {
            Exam => %w[id date result token_result],
            Doctor => %w[name email crm state],
            Patient => %w[citizen_id_number name email birth_date street_address city state],
            ExamType => %w[name limits],
          }, where: {
            'exam.token_result': request.params['token']
          }, version: 'V2'
        ).first

        return response.json data: exam, status: :ok unless exam.nil?

        response.json data: nil, status: :not_found
      end

      def self.tests request, response
        exams = Exam.select(joins: {
            Doctor => %w[doctor_id id],
            Patient => %w[patient_id id],
            ExamType => %w[exam_type_id id],
          }, fields_selection: {
            Exam => %w[id date result token_result],
            Doctor => %w[name email crm state],
            Patient => %w[citizen_id_number name email birth_date street_address city state],
            ExamType => %w[name limits],
          }, version: 'V2'
        )

        response.json data: exams, status: :ok
      end
    end
  end
end