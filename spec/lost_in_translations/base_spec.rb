require 'spec_helper'

describe LostInTranslations::Base do
  describe '.translation_data_field =' do
    context 'when it points to a real method' do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations::Base

          self.translation_data_field = :translation_json

          def translation_json
            @translation_json ||= {
              'en-GB' => { first_name: 'Jon', last_name: 'Snow' },
              'fr' => { first_name: 'Jean', last_name: 'Neige' }
            }
          end
        end

        LostInTranslations.define_translation_methods(@user_class, :first_name)

        @user = @user_class.new('Joao', 'Neve')
      end

      it 'LostInTranslations.translate must return a translation' do
        expect(LostInTranslations.translate(@user, :first_name, 'en-GB')).to \
          eq 'Jon'
      end

      it 'calling a field not translated, must return the original data' do
        I18n.with_locale('en-GB') do
          expect(@user.last_name).to eq 'Neve'
        end
      end

      context 'and the translation data does not contain results' do
        it 'LostInTranslations.translate must return nil' do
          expect(LostInTranslations.translate(@user, :first_name, :de)).to \
            be_nil
        end
      end
    end

    context 'when it DOES NOT point to a real method' do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations::Base

          self.translation_data_field = :translation_json
        end

        LostInTranslations.define_translation_methods(@user_class, :first_name)

        @user = @user_class.new('Joao', 'Neve')
      end

      it 'LostInTranslations.translate must raise an error' do
        expect { LostInTranslations.translate(@user, :first_name, 'en-GB') }
          .to raise_error(NotImplementedError)
      end

      it 'calling a field not translated, must return the original data' do
        I18n.with_locale('en-GB') do
          expect(@user.last_name).to eq 'Neve'
        end
      end
    end
  end

  describe '.force_locale_field =' do
    context 'when forces a locale' do
      before do
        @user_class = Struct.new(
          :first_name,
          :last_name,
          :title,
          :force_locale) do
          include LostInTranslations::Base

          self.translation_data_field = :translation_json

          def translation_json
            @translation_json ||= {
              'en-GB' => {
                first_name: 'Jon',
                last_name: 'Snow',
                title: 'King of the North'
              },
              'fr' => { first_name: 'Jean', last_name: 'Neige' }
            }
          end
        end

        LostInTranslations.define_translation_methods(
          @user_class,
          :first_name,
          :title
        )

        @user = @user_class.new('Joao', 'Neve', 'Rei do Norte', 'fr')
      end

      it 'LostInTranslations.translate must return a forced translation' do
        expect(LostInTranslations.translate(@user, :first_name, 'en-GB')).to \
          eq 'Jean'
      end

      it 'calling a field not translated, must return the original data' do
        I18n.with_locale('en-GB') do
          expect(@user.last_name).to eq 'Neve'
        end
      end

      context 'and the translation data does not contain results' do
        it 'LostInTranslations.translate must return nil' do
          expect(LostInTranslations.translate(@user, :title, :de)).to \
            be_nil
        end
      end
    end
  end
end
