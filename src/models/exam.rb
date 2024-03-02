
require_relative 'model'

class Exam < Model
  attr_accessor :id, :patient, :doctor, :exam_type, :date, :result, :token_result

  TABLE_NAME = 'exams'
end
