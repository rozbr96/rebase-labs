
class Patient < Model
  attr_accessor :id, :citizen_id_number, :name, :email, :birth_date, :street_address, :city, :state

  TABLE_NAME = 'patient'
  TABLE_COLUMNS = %i[citizen_id_number name email birth_date street_address city state]
end
