# encoding: UTF-8

shared_examples_for 'the readme example' do
  context 'when I18n.locale == :fr' do
    before { I18n.locale = :fr }
    after { I18n.locale = :pt }

    it 'should return what the readme says it does' do
      expect(@user.first_name).to eq 'Jean'
      expect(@user.last_name).to eq 'Neve'
      expect(@user.title).to be_nil

      I18n.with_locale(:en) do
        expect(@user.first_name).to eq 'Jon'
        expect(@user.last_name).to eq 'Neve'
        expect(@user.title).to be_nil
      end

      I18n.with_locale(:pt) do
        expect(@user.first_name).to eq 'Joao'
        expect(@user.last_name).to eq 'Neve'
        expect(@user.title).to eq 'Cavaleiro'
      end

      I18n.with_locale(:de) do
        expect(@user.first_name).to be_nil
        expect(@user.last_name).to eq 'Neve'
        expect(@user.title).to be_nil
      end

      expect(@user.translate(:first_name, :fr)).to eq 'Jean'
      expect(@user.translate(:first_name, :en)).to eq 'Jon'
      expect(@user.translate(:first_name, :pt)).to eq 'Joao'
      expect(@user.translate(:first_name, :de)).to be_nil

      expect(@user.fr_first_name).to eq 'Jean'
      expect(@user.en_first_name).to eq 'Jon'
      expect(@user.pt_first_name).to eq 'Joao'
      expect(@user.de_first_name).to be_nil
    end

    context 'when making use of setter translation methods' do
      before do
        @user.pt_first_name = 'João'
        @user.de_first_name = 'Hans'
      end

      it '#translation_data should be updated' do
        expect(@user.translation_data).to eq(
          en: { first_name: 'Jon', last_name: 'Snow' },
          pt: { first_name: 'João' },
          de: { first_name: 'Hans' },
          fr: { first_name: 'Jean', last_name: 'Neige' }
        )
      end

      it 'translation method should return the updated results' do
        expect(@user.translate(:first_name, :fr)).to eq 'Jean'
        expect(@user.translate(:first_name, :en)).to eq 'Jon'
        expect(@user.translate(:first_name, :pt)).to eq 'João'
        expect(@user.translate(:first_name, :de)).to eq 'Hans'
      end
    end

    context 'when the available_locales do not include :es' do
      it '#es_first_name should NOT be defined' do
        expect(@user.respond_to?(:es_first_name)).to be false
      end

      context 'when :es gets introduced' do
        before { I18n.available_locales.push(:es) }
        after { I18n.available_locales.pop }

        context 'and .define_translation_methods as NOT ran' do
          it '#es_first_name should NOT be defined' do
            expect(@user.respond_to?(:es_first_name)).to be false
          end
        end

        context 'and .define_translation_methods AS ran' do
          before { @user_class.define_translation_methods }

          it 'already defined method should work' do
            expect(@user.fr_first_name).to eq 'Jean'
            expect(@user.en_first_name).to eq 'Jon'
            expect(@user.de_first_name).to be_nil
            expect(@user.pt_first_name).to eq 'Joao'
          end

          it '#es_first_name SHOULD be defined' do
            expect(@user.respond_to?(:es_first_name)).to be true
            expect(@user.es_first_name).to be_nil
          end
        end
      end
    end
  end
end
