require 'spec_helper'

describe LostInTranslation::ClassMethods do

  describe '#translate' do

    context "when translating a field" do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslation

          translate :first_name

          def translation_data
            { en: { first_name: 'Jon', last_name: 'Snow' } }
          end
        end

        @user = @user_class.new('joao', 'neve')
      end

      it "#field must return a translation" do
        I18n.with_locale(:en) do
          expect(@user.first_name).to eq 'Jon'
        end
      end

      context "and the translation data doesn't contain results" do
        it "#field must return the original data" do
          I18n.with_locale(:fr) do
            expect(@user.first_name).to eq 'joao'
          end
        end
      end
    end

    context "when a particular field is not translated" do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslation

          translate :first_name

          def translation_data
            { en: { first_name: 'Jon', last_name: 'Snow' } }
          end
        end

        @user = @user_class.new('joao', 'neve')
      end

      it "#field must return the original data" do
        I18n.with_locale(:en) do
          expect(@user.last_name).to eq 'neve'
        end
      end
    end

  end

  describe '#translation_data_field =' do

    context "when it points to a real method" do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslation

          translate :first_name

          self.translation_data_field = :translation_json

          def translation_json
            { en: { first_name: 'Jon', last_name: 'Snow' } }
          end
        end

        @user = @user_class.new('joao', 'neve')
      end

      it "calling a translated field must return a translation" do
        I18n.with_locale(:en) do
          expect(@user.first_name).to eq 'Jon'
        end
      end

      context "and the translation data doesn't contain results" do
        it "calling a translated field must return the original data" do
          I18n.with_locale(:fr) do
            expect(@user.first_name).to eq 'joao'
          end
        end
      end
    end

    context "when it DOENS't point to a real method" do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslation

          translate :first_name

          self.translation_data_field = :translation_json
        end

        @user = @user_class.new('joao', 'neve')
      end

      it "calling a translated field, must raise an error" do
        I18n.with_locale(:en) do
          expect { @user.first_name }.to raise_error(NotImplementedError)
        end
      end

      it "calling a field not translated, must return the original data" do
        I18n.with_locale(:en) do
          expect(@user.last_name).to eq 'neve'
        end
      end
    end

  end

end
