require 'i18n'
require 'lost_in_translations/base'
require 'lost_in_translations/ruby'
require 'lost_in_translations/config'
require 'lost_in_translations/active_record'
require 'lost_in_translations/translator/base'

module LostInTranslations
  def self.included(base_class)
    if defined?(::ActiveRecord::Base) &&
       base_class.ancestors.include?(::ActiveRecord::Base)
      base_class.send(:include, LostInTranslations::ActiveRecord)
    else
      base_class.send(:include, Ruby)
    end
  end

  def self.config
    @config ||= Config.new('translation_data', Translator::Base, nil, 'force_locale')
  end

  def self.translate(*args)
    config.translator.translate(*args)
  end

  def self.assign_translation(*args)
    config.translator.assign_translation(*args)
  end

  def self.translation_data(object)
    config.translator.translation_data(object)
  end

  def self.define_translation_methods(object, *fields)
    fields.each do |field|
      define_dynamic_translation_method(object, field)
      define_particular_translation_methods(object, field)
    end
  end

  def self.define_dynamic_translation_method(object, method_name)
    object.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{method_name}
        translate(:#{method_name}, I18n.locale)
      end
    RUBY
  end

  def self.define_particular_translation_methods(object, attribute)
    I18n.available_locales.each do |locale|
      method_name = "#{locale.to_s.downcase.tr('-', '_')}_#{attribute}"

      define_translation_method(object, method_name, attribute, locale)
    end
  end

  def self.define_translation_method(object, method_name, attribute, locale)
    object.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{method_name}
        translate(:#{attribute}, :'#{locale}')
      end

      def #{method_name}=(value)
        assign_translation(:#{attribute}, value, :'#{locale}')
      end
    RUBY
  end

  def self.configure
    yield(config)
  end

  def self.infected_classes
    @infected_classes ||= []
  end

  def self.reload
    infected_classes.each(&:define_translation_methods)
  end
end
