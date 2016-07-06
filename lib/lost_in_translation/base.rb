module LostInTranslation
  module Base

    def translate(field, locale = I18n.locale)
      LostInTranslation.translate(self, field, locale)
    end

  end
end
