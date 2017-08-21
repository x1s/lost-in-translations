module LostInTranslations
  module Base
    def self.included(base_class)
      LostInTranslations.infected_classes.push(base_class)

      base_class.extend ClassMethods
    end

    def translate(field, locale = I18n.locale)
      translation = LostInTranslations.translate(self, field, locale)

      if translation.nil? && fallback_to_default_locale(locale)
        translation = call_original_field(self, field)
      end

      translation
    end

    def assign_translation(field, value, locale = I18n.locale)
      LostInTranslations.assign_translation(self, field, value, locale)
    end

    def fallback_to_default_locale(locale)
      LostInTranslations.config.fallback_to_default_locale ||
        locale.to_sym == I18n.default_locale.to_sym
    end

    module ClassMethods
      attr_writer :translation_data_field
      attr_writer :force_locale_field

      def translation_data_field
        @translation_data_field ||
          LostInTranslations.config.translation_data_field
      end

      def force_locale_field
        @force_locale_field ||
          LostInTranslations.config.force_locale_field
      end

      def translation_fields
        @translation_fields ||= []
      end

      def translate(*fields)
        translation_fields.concat(fields)

        define_translation_methods
      end
    end
  end
end
