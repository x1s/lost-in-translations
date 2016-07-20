module LostInTranslations
  module ActiveRecord

    module ClassMethods

      def define_translation_methods
        LostInTranslations.define_translation_methods self, *translation_fields
      end

    end

    def self.included(base_class)
      base_class.send(:include, Base)
      base_class.extend ClassMethods
    end

    def call_original_field(object, field)
      object.read_attribute(field)
    end

  end
end
