require 'spec_helper'

describe LostInTranslations do

  describe "#define_translation_methods" do
    context "when the passed methods do not exist" do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations
        end

        LostInTranslations.define_translation_methods(@user_class, :unknown)

        @user = @user_class.new('Joao', 'Neve')
      end

      it "#unknown should be defined" do
        expect(@user.respond_to?(:unknown)).to be true
      end

      it "#<I18n.available_locales>_unknown should be defined" do
        I18n.available_locales.each do |locale|
          expect(@user.respond_to?("#{locale}_unknown")).to be true
        end
      end
    end

    context "when the passed methods do exist" do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations
        end

        LostInTranslations.define_translation_methods(@user_class, :first_name)

        @user = @user_class.new('Joao', 'Neve')
      end

      it "#first_name should be defined" do
        expect(@user.respond_to?(:first_name)).to be true
      end

      it "#<I18n.available_locales>_first_name should be defined" do
        I18n.available_locales.each do |locale|
          expect(@user.respond_to?("#{locale}_first_name")).to be true
        end
      end
    end
  end

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

  describe "#translation_data" do

    context "when the object.translation_data is nil" do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations

          translate :first_name

          attr_accessor :translation_data
        end

        @user = @user_class.new('joao', 'neve')
      end

      it "should return an empty Hash" do
        expect(LostInTranslations.translation_data(@user)).to eq({})
        expect(@user.translation_data).to eq({})
      end
    end

    context "when setting the #config.translation_data_field to a known method" do
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

      it "should return the known method results" do
        expect(LostInTranslations.translation_data(@user)).to eq({ en: { first_name: 'Jon', last_name: 'Snow' } })
      end
    end

    context "when setting the #config.translation_data_field to an unknown method" do
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

      it "should raise an error" do
        expect { LostInTranslations.translation_data(@user) }.to raise_error(NotImplementedError)
      end
    end

    context "when changing the #config.translator" do
      before do
        LostInTranslations.configure do |config|
          config.translator = Class.new(LostInTranslations::Translator::Base) do
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
      after { LostInTranslations.config.translator = LostInTranslations::Translator::Base }

      it "should return the known method results" do
        expect(LostInTranslations.translation_data(@user)).to eq({ en: { first_name: 'Jon', last_name: 'Snow' } })
      end
    end

  end

end
