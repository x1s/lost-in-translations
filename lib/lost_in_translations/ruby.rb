module LostInTranslations
  module Ruby

    module ClassMethods

      def translate(*fields)
        fields.each do |field|
          alias_method Ruby.original_field_name(field), field.to_sym
        end

        LostInTranslations.define_translation_methods(self, *fields)
      end

    end

    def self.included(base_class)
      base_class.send(:include, Base)
      base_class.extend ClassMethods
    end

    include Base

    def translate(field, locale = I18n.locale)
      translation = LostInTranslations.translate(self, field, locale)

      if translation.nil? && locale.to_sym == I18n.default_locale.to_sym
        translation = Ruby.call_original_field(self, field)
      end

      translation
    end

    def assign_translation(field, value, locale = I18n.locale)
      LostInTranslations.assign_translation(self, field, value, locale)
    end

    def self.call_original_field(object, field)
      method_name = Ruby.original_field_name(field)

      return object.send(field) unless object.respond_to?(method_name)

      object.send(method_name)
    end

    def self.original_field_name(field)
      "original_field_#{field}".to_sym
    end

  end
end
