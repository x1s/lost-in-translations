require 'i18n'
require 'lost_in_translations/base'
require 'lost_in_translations/ruby'
require 'lost_in_translations/config'
require 'lost_in_translations/translator'
require 'lost_in_translations/active_record'

module LostInTranslations

  def self.included(base_class)
    if defined?(::ActiveRecord::Base) &&
       base_class.ancestors.include?(::ActiveRecord::Base)
      base_class.include LostInTranslations::ActiveRecord
    else
      base_class.include Ruby
    end
  end

  def self.config
    @config ||= Config.new('translation_data', Translator)
  end

  def self.translate(*args)
    config.translator.translate(*args)
  end

  def self.define_translation_methods(object, *fields)
    fields.each do |field|
      object.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{field}
          translate(:#{field}, I18n.locale)
        end
      RUBY
    end
  end

  def self.configure
    yield(config)
  end

end
