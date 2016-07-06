module LostInTranslation
  module ClassMethods

    def translate(*fields)
      fields.each do |field|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          alias_method :original_field_#{field}, :#{field}

          def #{field}
            translate(:#{field}, I18n.locale)
          end
        RUBY
      end
    end

    attr_writer :translation_data_field

    def translation_data_field
      @translation_data_field || LostInTranslation.config.translation_data_field
    end

  end
end
