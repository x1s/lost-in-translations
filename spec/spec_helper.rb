require "codeclimate-test-reporter"

CodeClimate::TestReporter.start

require "simplecov"

SimpleCov.start do
  root("lib/")
  coverage_dir("../tmp/coverage/")
end

$: << File.expand_path('../', File.dirname(__FILE__))

require 'pry'
require 'active_record'
require 'lost_in_translations'

I18n.available_locales = [:en, :pt, :fr, :de]
I18n.default_locale = :pt

ActiveRecord::Base.establish_connection \
  pool: 5,
  timeout: 5000,
  adapter: 'sqlite3',
  database: File.expand_path('../spec/support/db/test.sqlite3', File.dirname(__FILE__))

Dir["./spec/**/support/**/*.rb"].each do |file|
  require file
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true

  config.order = 'random'
end
