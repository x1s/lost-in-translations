module LostInTranslations
  module ActiveRecord

    def self.included(base_class)
      base_class.send(:include, Base)
    end

    def initialize(*args, &block)
      super(*args, &block)

      LostInTranslations.define_translation_methods \
        self,
        *self.class.translation_fields
    end

    def call_original_field(object, field)
      object.read_attribute(field)
    end

  end
end
