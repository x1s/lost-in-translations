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
      base_class.class_eval do
        include Base
        extend ClassMethods
      end
    end

    def call_original_field(object, field)
      method_name = Ruby.original_field_name(field)

      return object.send(field) unless object.respond_to?(method_name)

      object.send(method_name)
    end

    def self.original_field_name(field)
      "original_field_#{field}".to_sym
    end

  end
end
