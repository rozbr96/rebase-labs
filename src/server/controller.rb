
class Controller
  def self.tests request
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
    ).to_json

    request.client.puts "HTTP/1.1 200 OK"
    request.client.puts "Content-type: application/json"
    request.client.puts ""
    request.client.puts exams
    request.client.close
  end
end
