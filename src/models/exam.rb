
require_relative 'model'

class Exam < Model
  attr_accessor :id, :patient, :doctor, :exam_type, :date, :result, :token_result

  TABLE_NAME = 'exam'
  TABLE_COLUMNS = %i[patient_id doctor_id exam_type_id date result token_result]

  def self.select joins:, fields_selection:, where: {}, version: 'V1'
    v1_data = super(joins:, fields_selection:, where:)

    return v1_data if version == 'V1'

    v2_data v1_data
  end

  private

  def self.v2_data rows
    dates = {}
    doctors = {}
    patients = {}
    tokens = []
    tests = Hash.new { |hash, key| hash[key] = [] }

    rows.each do |row_data|
      token = row_data['exam_token_result']
      patients[token] = get_patient_data row_data
      doctors[token] = get_doctor_data row_data
      tests[token] << get_test_data(row_data)
      dates[token] = row_data['exam_date']
      tokens << token
    end

    tokens.uniq.map do |token|
      {
        :patient => patients[token],
        :doctor => doctors[token],
        :tests => tests[token],
        :date => dates[token],
        :result_token => token
      }
    end
  end

  def self.get_doctor_data row_data
    {
      :name => row_data['doctor_name'],
      :email => row_data['doctor_email'],
      :crm => row_data['doctor_crm'],
      :state => row_data['doctor_state']
    }
  end

  def self.get_patient_data row_data
    {
      :citizen_id_number => row_data['patient_citizen_id_number'],
      :name => row_data['patient_name'],
      :email => row_data['patient_email'],
      :birth_date => row_data['patient_birth_date'],
      :street_address => row_data['patient_street_address'],
      :city => row_data['patient_city'],
      :state => row_data['patient_state']
    }
  end

  def self.get_test_data row_data
    {
      :type => row_data['exam_type_name'],
      :result => row_data['exam_result'],
      :limits => row_data['exam_type_limits']
    }
  end
end
