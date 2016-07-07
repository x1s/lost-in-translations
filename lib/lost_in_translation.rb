require 'i18n'
require 'lost_in_translation/base'
require 'lost_in_translation/ruby'
require 'lost_in_translation/config'
require 'lost_in_translation/translator'
require 'lost_in_translation/active_record'

module LostInTranslation

  def self.included(base_class)
    if defined?(::ActiveRecord::Base) &&
       base_class.ancestors.include?(::ActiveRecord::Base)
      base_class.include LostInTranslation::ActiveRecord
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
