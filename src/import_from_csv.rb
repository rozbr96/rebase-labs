
require 'csv'
require_relative 'models'


rows = CSV.read './sample/data.csv', col_sep: ';'
columns = rows.shift

patients_data = {}
doctors_data = {}
exam_types_data = {}
exams_data = []

rows.each do |row|
  data = row.each_with_object({}).with_index do |(cell, acc), idx|
    column = columns[idx]
    acc[column] = cell
  end

  patient_data = {
    citizen_id_number: data['cpf'], name: data['nome paciente'],
    email: data['email paciente'], birth_date: data['data nascimento paciente'],
    street_address: data['endereço/rua paciente'], city: data['cidade paciente'],
    state: data['estado patiente']
  }
  patient_data_key = patient_data.values.join
  patients_data[patient_data_key] = patient_data

  doctor_data = {
    name: data['nome médico'], email: data['email médico'],
    crm: data['crm médico'], state: data['crm médico estado']
  }
  doctor_data_key = doctor_data.values.join
  doctors_data[doctor_data_key] = doctor_data

  exam_type_data = { name: data['tipo exame'], limits: data['limites tipo exame'] }
  exam_type_data_key = exam_type_data.values.join
  exam_types_data[exam_type_data_key] = exam_type_data

  exams_data << {
    date: data['data exame'], result: data['resultado tipo exame'],
    token_result: data['token resultado exame'],
    citizen_id_number: patient_data[:citizen_id_number],
    state: doctor_data[:state], crm: doctor_data[:crm],
    name: exam_type_data[:name]
  }
end

Patient.create_multiple patients_data.values
Doctor.create_multiple doctors_data.values
ExamType.create_multiple exam_types_data.values

until exams_data.empty?
  exams = exams_data.shift 500

  Exam.create_multiple exams, foreign_keys: {
    patient_id: { get_from: Patient::TABLE_NAME, using: %i[citizen_id_number] },
    doctor_id: { get_from: Doctor::TABLE_NAME, using: %i[crm state] },
    exam_type_id: { get_from: ExamType::TABLE_NAME, using: %i[name] },
  }
end
