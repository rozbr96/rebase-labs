
require_relative 'model'

class ExamType < Model
  attr_accessor :id, :name, :limits

  TABLE_NAME = 'exam_types'
end
