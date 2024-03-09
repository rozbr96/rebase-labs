
class DataExtractor
  def self.get_doctor_data row_data
    {
      name: row_data['nome médico'], email: row_data['email médico'],
      crm: row_data['crm médico'], state: row_data['crm médico estado']
    }
  end

  def self.get_exam_data row_data
    {
      date: row_data['data exame'], result: row_data['resultado tipo exame'],
      token_result: row_data['token resultado exame'],
      citizen_id_number: row_data['cpf'], state: row_data['crm médico estado'],
      crm: row_data['crm médico'], name: row_data['tipo exame']
    }
  end

  def self.get_exam_type_data row_data
    {
      name: row_data['tipo exame'], limits: row_data['limites tipo exame']
    }
  end

  def self.get_patient_data row_data
    {
      citizen_id_number: row_data['cpf'], name: row_data['nome paciente'],
      email: row_data['email paciente'], birth_date: row_data['data nascimento paciente'],
      street_address: row_data['endereço/rua paciente'], city: row_data['cidade paciente'],
      state: row_data['estado patiente']
    }
  end

  def self.get_row_data columns, row
    columns.zip(row).reduce({}) do |row_data, (column, value)|
      row_data.update column => value
    end
  end
end
