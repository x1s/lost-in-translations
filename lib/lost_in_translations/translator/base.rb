module LostInTranslations
  module Translator
    class Base

      def self.translate(object, field, locale)
        data = translation_data(object)

        translations = data[locale.to_sym] || data[locale.to_s] || {}

        translations[field.to_sym] || translations[field.to_s]
      end

      def self.assign_translation(object, field, value, locale)
        data = translation_data(object)

        translations = data[locale.to_sym] || data[locale.to_s]

        translations ||= data[locale.to_sym] = {}

        translations[field.to_sym] = value
      end

      def self.translation_data(object)
        translation_data_field = translation_data_field(object)

        data = object.send(translation_data_field)

        if data.nil? && object.respond_to?("#{translation_data_field}=")
          data = object.send("#{translation_data_field}=", {})
        end

        data
      end

      def self.translation_data_field(object)
        translation_data_field = object.class.translation_data_field

        unless object.respond_to?(translation_data_field)
          raise \
            NotImplementedError,
            "#{object.class.name} does not implement .#{translation_data_field}"
        end

        translation_data_field
      end

    end
  end
end
