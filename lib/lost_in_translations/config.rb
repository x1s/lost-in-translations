module LostInTranslations
  Config = Struct.new \
    :translation_data_field, :translator, :fallback_to_default_locale,
    :force_locale_field
end
