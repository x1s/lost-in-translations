require "simplecov"

SimpleCov.start do
  root("lib/")
  coverage_dir("../tmp/coverage/")
end

$: <<  File.expand_path('../', File.dirname(__FILE__))

require 'lost_in_translation'
require 'pry-byebug'

I18n.available_locales = [:en, :pt, :fr]
I18n.default_locale = :pt

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true

  config.order = 'random'
end
