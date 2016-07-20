module LostInTranslations
  module Ruby

    module ClassMethods

      def define_translation_methods
        translation_fields.each do |field|
          next if instance_methods.include?(Ruby.original_field_name(field))

          class_eval do
            alias_method Ruby.original_field_name(field), field.to_sym
          end
        end

        LostInTranslations.define_translation_methods self, *translation_fields
      end

    end

    def self.included(base_class)
      base_class.send(:include, Base)
      base_class.extend ClassMethods
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
