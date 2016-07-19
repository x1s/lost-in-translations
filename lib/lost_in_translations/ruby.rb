module LostInTranslations
  module Ruby

    def self.included(base_class)
      base_class.send(:include, Base)
    end

    def initialize(*args, &block)
      super(*args, &block)

      fields = self.class.translation_fields

      fields.each do |field|
        self.class_eval do
          alias_method Ruby.original_field_name(field), field.to_sym
        end
      end

      LostInTranslations.define_translation_methods(self, *fields)
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
