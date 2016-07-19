module LostInTranslations
  module Base

    def self.included(base_class)
      base_class.extend ClassMethods
    end

    def translate(field, locale = I18n.locale)
      translation = LostInTranslations.translate(self, field, locale)

      if translation.nil? && locale.to_sym == I18n.default_locale.to_sym
        translation = call_original_field(self, field)
      end

      translation
    end

    def assign_translation(field, value, locale = I18n.locale)
      LostInTranslations.assign_translation(self, field, value, locale)
    end

    module ClassMethods

      attr_writer :translation_data_field

      def translation_data_field
        @translation_data_field ||
          LostInTranslations.config.translation_data_field
      end

      def translation_fields
        @translation_fields ||= []
      end

      def translate(*fields)
        translation_fields.concat(fields)
      end

    end

  end
end
