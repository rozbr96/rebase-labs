
require_relative 'model'

class Doctor < Model
  attr_accessor :id, :name, :email, :crm, :state

  TABLE_NAME = 'doctor'
  TABLE_COLUMNS = %i[name email crm state]
end
