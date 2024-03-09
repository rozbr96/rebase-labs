
require 'capybara/rspec'
require_relative '../models'

Capybara.default_driver = :selenium_headless

RSpec.configure do |config|
  config.after :each do
    Exam.delete_all
    Doctor.delete_all
    Patient.delete_all
    ExamType.delete_all
  end
end

def get_filepath_for filename
  app_dir = File.absolute_path '.'
  File.join app_dir, 'spec', 'support', filename
end

def read_file_from_support filename
  File.read get_filepath_for filename
end
