require 'spec_helper'

describe LostInTranslations::Ruby do

  describe '.translate' do

    context "when translating a field" do
      before do
        @user_class = Struct.new(:title, :first_name, :last_name) do
          include LostInTranslations

          translate :title, :first_name

          def translation_data
            {
              en: { first_name: 'Jon', last_name: 'Snow' },
              fr: { first_name: 'Jean', last_name: 'Neige' }
            }
          end
        end

        @user = @user_class.new('Cavaleiro', 'Joao', 'Neve')
      end

      it_behaves_like "a proper translator"
    end

    context "when a particular field is not translated" do
      before do
        @user_class = Struct.new(:title, :first_name, :last_name) do
          include LostInTranslations

          translate :title, :first_name

          def translation_data
            {
              en: { first_name: 'Jon', last_name: 'Snow' },
              fr: { first_name: 'Jean', last_name: 'Neige' }
            }
          end
        end

        @user = @user_class.new('Cavaleiro', 'Joao', 'Neve')
      end

      it "#field must return the original data" do
        I18n.with_locale(:en) do
          expect(@user.last_name).to eq 'Neve'
        end
      end
    end

  end

end
