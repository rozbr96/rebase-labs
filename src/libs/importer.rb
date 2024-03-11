
class Importer
  attr_reader :columns, :rows, :doctors, :exams, :exam_types, :patients

  BATCH_SIZE = 500

  def initialize csv_filepath: nil, csv_raw_data: nil, col_sep: ';'
    @rows = CSV.read(csv_filepath, col_sep:) if csv_filepath
    @rows = csv_raw_data.lines.map { |line| line.chomp.split col_sep } if csv_raw_data

    raise ArgumentError.new 'Either csv_filepath or csv_raw_data should be given' if @rows.nil?

    @columns = @rows.shift

    @doctors = []
    @exams = []
    @exam_types = []
    @patients = []
  end

  def prepare_data
    @exams = []
    patients_data = {}
    doctors_data = {}
    exam_types_data = {}

    @rows.each do |row|
      row_data = DataExtractor.get_row_data @columns, row

      patient_data = DataExtractor.get_patient_data row_data
      patients_data[patient_data[:citizen_id_number]] = patient_data

      doctor_data = DataExtractor.get_doctor_data row_data
      doctors_data["#{doctor_data[:crm]}_#{doctor_data[:state]}"] = doctor_data

      exam_type_data = DataExtractor.get_exam_type_data row_data
      exam_types_data[exam_type_data[:name]] = exam_type_data

      @exams.push DataExtractor.get_exam_data row_data
    end

    @patients = patients_data.values
    @doctors = doctors_data.values
    @exam_types = exam_types_data.values

    self
  end

  def save_all
    save_doctors
    save_patients
    save_exam_types
    save_exams
  end

  private

  def save_doctors
    until @doctors.empty?
      Doctor.create_multiple @doctors.shift BATCH_SIZE
    end
  end

  def save_exams
    until @exams.empty?
      Exam.create_multiple @exams.shift(BATCH_SIZE), foreign_keys: {
        patient_id: { get_from: Patient::TABLE_NAME, using: %i[citizen_id_number] },
        doctor_id: { get_from: Doctor::TABLE_NAME, using: %i[crm state] },
        exam_type_id: { get_from: ExamType::TABLE_NAME, using: %i[name] },
      }
    end
  end

  def save_exam_types
    until @exam_types.empty?
      ExamType.create_multiple @exam_types.shift BATCH_SIZE
    end
  end

  def save_patients
    until @patients.empty?
      Patient.create_multiple @patients.shift BATCH_SIZE
    end
  end
end
