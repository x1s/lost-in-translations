module LostInTranslations
  module ActiveRecord

    module ClassMethods

      def translate(*fields)
        LostInTranslations.define_translation_methods(self, *fields)
      end

    end

    def self.included(base_class)
      base_class.include Base
      base_class.extend ClassMethods
    end

    def translate(field, locale = I18n.locale)
      LostInTranslations.translate(self, field, locale) ||
        ActiveRecord.call_original_field(self, field)
    end

    def self.call_original_field(object, field)
      object.read_attribute(field)
    end

  end
end
