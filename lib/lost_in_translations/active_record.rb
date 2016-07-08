module LostInTranslations
  module ActiveRecord

    module ClassMethods

      def translate(*fields)
        LostInTranslations.define_translation_methods(self, *fields)
      end

    end

    def self.included(base_class)
      base_class.send(:include, Base)
      base_class.extend ClassMethods
    end

    def translate(field, locale = I18n.locale)
      translation = LostInTranslations.translate(self, field, locale)

      if translation.nil? && locale.to_sym == I18n.default_locale.to_sym
        translation = ActiveRecord.call_original_field(self, field)
      end

      translation
    end

    def assign_translation(field, value, locale = I18n.locale)
      LostInTranslations.assign_translation(self, field, value, locale)
    end

    def self.call_original_field(object, field)
      object.read_attribute(field)
    end

  end
end
