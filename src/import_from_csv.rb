
require 'csv'
require_relative 'models'


rows = CSV.read './sample/data.csv', col_sep: ';'
cache = {
  :patients => {},
  :doctors => {},
  :exam_types => {},
}

columns = rows.shift

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

  doctor_data = {
    name: data['nome médico'], email: data['email médico'],
    crm: data['crm médico'], state: data['crm médico estado']
  }

  exam_type_data = { name: data['tipo exame'], limits: data['limites tipo exame'] }

  patient_data_key = patient_data.values.join
  patient = cache[:patients][patient_data_key] || Patient.get_or_create(patient_data)
  puts "Patient: #{patient['id']}"
  cache[:patients][patient_data_key] = patient

  doctor_data_key = doctor_data.values.join
  doctor = cache[:doctors][doctor_data_key] || Doctor.get_or_create(doctor_data)
  puts "Doctor: #{doctor['id']}"
  cache[:doctors][doctor_data_key] = doctor

  exam_type_data_key = exam_type_data.values.join
  exam_type = cache[:exam_types][exam_type_data_key] || ExamType.get_or_create(exam_type_data)
  puts "Exam Type: #{exam_type['id']}"
  cache[:exam_types][exam_type_data_key] = exam_type

  exam_data = {
    patient_id: patient['id'], doctor_id: doctor['id'], exam_type_id: exam_type['id'],
    date: data['data exame'], result: data['resultado tipo exame'],
    token_result: data['token resultado exame']
  }

  exam = Exam.get_or_create exam_data
  puts "Exam: #{exam['id']}"
end
