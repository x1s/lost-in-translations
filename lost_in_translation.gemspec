lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'lost_in_translation/version'

Gem::Specification.new do |gem|
  gem.name = "lost_in_translation"
  gem.version = LostInTranslation::VERSION
  gem.license = "NONE"
  gem.authors = ["StreetBees Dev Team"]
  gem.email = "dev@streetbees.com"
  gem.summary = "Ruby Translation Gem"
  gem.description = "Super light Translation Ruby Gem agnostic to your framework and source data"
  gem.homepage = "https://github.com/streetbees/lost-in-translation"

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '3.4.0'
  gem.add_development_dependency 'byebug', '8.2.5'
  gem.add_development_dependency 'simplecov', '0.11.2'
  gem.add_development_dependency 'pry-byebug', '3.3.0'

  gem.add_dependency 'i18n', '>= 0.7'
end
