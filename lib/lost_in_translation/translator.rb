module LostInTranslation
  class Translator

    def self.translate(object, field, locale)
      translations = translations_for(object, locale) || {}

      translations[field.to_sym] || translations[field.to_s]
    end

    def self.translations_for(object, locale)
      translations = translation_data(object) || {}

      translations[locale.to_sym] || translations[locale.to_s]
    end

    def self.translation_data(object)
      translation_data_field = object.class.translation_data_field

      unless object.respond_to?(translation_data_field)
        raise \
          NotImplementedError,
          "#{object.class.name} does not respond to .#{translation_data_field}"
      end

      object.send(translation_data_field)
    end

  end
end
