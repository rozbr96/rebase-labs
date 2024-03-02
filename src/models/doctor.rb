
require_relative 'model'

class Doctor < Model
  attr_accessor :id, :name, :email, :crm, :state

  TABLE_NAME = 'doctors'
end
