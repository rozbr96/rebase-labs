
module Controller
  module API
    module V2
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
          }
        )

        dates = {}
        doctors = {}
        patients = {}
        tokens = []
        tests = Hash.new { |hash, key| hash[key] = [] }

        exams.each do |exam|
          patients[exam['exam_token_result']] ||= {
            :citizen_id_number => exam['patient_citizen_id_number'],
            :name => exam['patient_name'],
            :email => exam['patient_email'],
            :birth_date => exam['patient_birth_date'],
            :street_address => exam['patient_street_address'],
            :city => exam['patient_city'],
            :state => exam['patient_state']
          }

          doctors[exam['exam_token_result']] ||= {
            :name => exam['doctor_name'],
            :email => exam['doctor_email'],
            :crm => exam['doctor_crm'],
            :state => exam['doctor_state']
          }

          dates[exam['exam_token_result']] ||= exam['exam_date']

          tests[exam['exam_token_result']] << {
            :type => exam['exam_type_name'],
            :result => exam['exam_result'],
            :limits => exam['exam_type_limits']
          }

          tokens << exam['exam_token_result']
        end

        exams = tokens.uniq.map do |token|
          {
            :patient => patients[token],
            :doctor => doctors[token],
            :tests => tests[token],
            :date => dates[token],
            :result_token => token
          }
        end

        response.json data: exams, status: :ok
      end
    end
  end
end
