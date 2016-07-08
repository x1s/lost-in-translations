module LostInTranslations
  module ActiveRecord

    module ClassMethods

      def translate(*fields)
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
      object.read_attribute(field)
    end

  end
end
