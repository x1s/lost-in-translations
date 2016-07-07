module LostInTranslations
  module Base

    def self.included(base_class)
      base_class.extend ClassMethods
    end

    module ClassMethods

      attr_writer :translation_data_field

      def translation_data_field
        @translation_data_field ||
          LostInTranslations.config.translation_data_field
      end

    end

  end
end
