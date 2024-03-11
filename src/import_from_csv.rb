
require 'csv'

require_relative 'db/postgres/connection'
require_relative 'db/postgres/parser'

require_relative 'models/model'
require_relative 'models/doctor'
require_relative 'models/exam'
require_relative 'models/exam_type'
require_relative 'models/patient'

require_relative 'libs/data_extractor'
require_relative 'libs/importer'


importer = Importer.new csv_filepath: './sample/data.csv'
importer.prepare_data.save_all
