
require_relative 'libs/importer'

importer = Importer.new csv_filepath: './sample/data.csv'
importer.prepare_data.save_all
