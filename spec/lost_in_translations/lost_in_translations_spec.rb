require 'spec_helper'

describe LostInTranslations do

  describe "#included" do
    context "when the object inherits from ActiveRecord" do
      before do
        @user_class = Class.new(ActiveRecord::Base) do
          self.table_name = 'users'

          include LostInTranslations
        end
      end

      it "LostInTranslations::ActiveRecord must be included" do
        expect(@user_class.ancestors.include?(LostInTranslations::ActiveRecord)).to be true
      end
    end

    context "when the object DOES NOT inherit from ActiveRecord" do
      before do
        @user_class = Class.new { include LostInTranslations }
      end

      it "LostInTranslations::Ruby must be included" do
        expect(@user_class.ancestors.include?(LostInTranslations::Ruby)).to be true
      end
    end
  end

  describe "#config.translation_data_field" do

    context "when setting the 'translation_data_field' to a known method" do
      before do
        LostInTranslations.configure do |config|
          config.translation_data_field = 'translation_json'
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations

          translate :first_name

          def translation_json
            { en: { first_name: 'Jon', last_name: 'Snow' } }
          end
        end

        @user = @user_class.new('joao', 'neve')
      end
      after { LostInTranslations.config.translation_data_field = 'translation_data' }

      it "calling a translated field must return a translation" do
        I18n.with_locale(:en) do
          expect(@user.first_name).to eq 'Jon'
        end
      end
    end

    context "when setting the 'translation_data_field' to an unknown method" do
      before do
        LostInTranslations.configure do |config|
          config.translation_data_field = 'translation_json'
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations

          translate :first_name
        end

        @user = @user_class.new('joao', 'neve')
      end
      after { LostInTranslations.config.translation_data_field = 'translation_data' }

      it "calling a translated field, must raise an error" do
        I18n.with_locale(:en) do
          expect { @user.first_name }.to raise_error(NotImplementedError)
        end
      end
    end

  end

  describe "#config.translator" do

    context "changing the source of the translation_data" do
      before do
        LostInTranslations.configure do |config|
          config.translator = Class.new(LostInTranslations::Translator) do
            def self.translation_data(object)
              { en: { first_name: 'Jon', last_name: 'Snow' } }
            end
          end
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations

          translate :first_name
        end

        @user = @user_class.new('joao', 'neve')
      end
      after { LostInTranslations.config.translator = LostInTranslations::Translator }

      it "calling a translated field must return a translation" do
        I18n.with_locale(:en) do
          expect(@user.first_name).to eq 'Jon'
        end
      end
    end

  end

end
