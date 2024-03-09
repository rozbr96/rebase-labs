
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
