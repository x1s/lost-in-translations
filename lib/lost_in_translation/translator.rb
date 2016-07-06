module LostInTranslation
  class Translator

    def self.translate(object, field, locale)
      (translations_for(object, locale) || {})[field.to_sym]
    end

    protected ######################### PROTECTED ##############################

    def self.translations_for(object, locale)
      translation_data(object)[locale.to_sym]
    end

    def self.translation_data(object)
      translation_data_field = object.class.translation_data_field

      unless object.respond_to?(translation_data_field)
        fail \
          NotImplementedError,
          "#{object.class.name} does not respond to .#{translation_data_field}"
      end

      object.send(translation_data_field)
    end

  end
end
