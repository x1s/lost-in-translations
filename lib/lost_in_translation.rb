require 'i18n'
require 'lost_in_translation/base'
require 'lost_in_translation/config'
require 'lost_in_translation/translator'
require 'lost_in_translation/class_methods'

module LostInTranslation

  def self.included(base_class)
    base_class.extend ClassMethods
    base_class.include Base
  end

  def self.config
    @config ||= Config.new('translation_data', Translator)
  end

  def self.translate(*args)
    config.translator.translate(*args) || call_original_field(*args)
  end

  def self.call_original_field(object, field, _)
    method_name = "original_field_#{field}"

    return object.send(field) unless object.respond_to?(method_name)

    object.send(method_name)
  end

  def self.configure
    yield(config)
  end

end
