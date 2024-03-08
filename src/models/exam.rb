
require_relative 'model'

class Exam < Model
  attr_accessor :id, :patient, :doctor, :exam_type, :date, :result, :token_result

  TABLE_NAME = 'exam'
  TABLE_COLUMNS = %i[patient_id doctor_id exam_type_id date result token_result]
end
