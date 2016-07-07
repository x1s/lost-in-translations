require 'spec_helper'

describe LostInTranslation do

  describe "#included" do
    context "when the object inherits from ActiveRecord" do
      before do
        @user_class = Class.new(ActiveRecord::Base) do
          self.table_name = 'users'

          include LostInTranslation
        end
      end

      it "LostInTranslation::ActiveRecord must be included" do
        expect(@user_class.ancestors.include?(LostInTranslation::ActiveRecord)).to be true
      end
    end

    context "when the object DOES NOT inherit from ActiveRecord" do
      before do
        @user_class = Class.new { include LostInTranslation }
      end

      it "LostInTranslation::Ruby must be included" do
        expect(@user_class.ancestors.include?(LostInTranslation::Ruby)).to be true
      end
    end
  end

  describe "#config.translation_data_field" do

    context "when setting the 'translation_data_field' to a known method" do
      before do
        LostInTranslation.configure do |config|
          config.translation_data_field = 'translation_json'
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslation

          translate :first_name

          def translation_json
            { en: { first_name: 'Jon', last_name: 'Snow' } }
          end
        end

        @user = @user_class.new('joao', 'neve')
      end
      after { LostInTranslation.config.translation_data_field = 'translation_data' }

      it "calling a translated field must return a translation" do
        I18n.with_locale(:en) do
          expect(@user.first_name).to eq 'Jon'
        end
      end
    end

    context "when setting the 'translation_data_field' to an unknown method" do
      before do
        LostInTranslation.configure do |config|
          config.translation_data_field = 'translation_json'
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslation

          translate :first_name
        end

        @user = @user_class.new('joao', 'neve')
      end
      after { LostInTranslation.config.translation_data_field = 'translation_data' }

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
        LostInTranslation.configure do |config|
          config.translator = Class.new(LostInTranslation::Translator) do
            def self.translation_data(object)
              { en: { first_name: 'Jon', last_name: 'Snow' } }
            end
          end
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslation

          translate :first_name
        end

        @user = @user_class.new('joao', 'neve')
      end
      after { LostInTranslation.config.translator = LostInTranslation::Translator }

      it "calling a translated field must return a translation" do
        I18n.with_locale(:en) do
          expect(@user.first_name).to eq 'Jon'
        end
      end
    end

  end

end
