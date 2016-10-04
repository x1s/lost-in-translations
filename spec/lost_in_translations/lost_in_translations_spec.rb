require 'spec_helper'

describe LostInTranslations do
  describe '#reload' do
    context 'when the available_locales do not include :es' do
      before do
        LostInTranslations.infected_classes.clear

        @user_class1 = Struct.new(:first_name, :last_name) do
          include LostInTranslations::Ruby

          translate :first_name
        end

        @user_class2 = Class.new(ActiveRecord::Base) do
          self.table_name = 'users'

          include LostInTranslations::ActiveRecord

          translate :last_name
        end

        @user1 = @user_class1.new('Joao', 'Neve')
        @user2 = @user_class2.new \
          title: 'Cavaleiro',
          first_name: 'Joao',
          last_name: 'Neve'
      end

      it '#pt_first_name SHOULD be defined' do
        expect(@user1.respond_to?(:pt_first_name)).to be true
        expect(@user2.respond_to?(:pt_last_name)).to be true
      end

      it '#es_first_name should NOT be defined' do
        expect(@user1.respond_to?(:es_first_name)).to be false
        expect(@user1.respond_to?(:es_last_name)).to be false
      end

      context 'when :es gets introduced' do
        before { I18n.available_locales.push(:es) }
        after { I18n.available_locales.pop }

        context 'and .reload as NOT ran' do
          it '#es_first_name should NOT be defined' do
            expect(@user1.respond_to?(:es_first_name)).to be false
            expect(@user2.respond_to?(:es_last_name)).to be false
          end
        end

        context 'and .define_translation_methods AS ran' do
          before { LostInTranslations.reload }

          it '#pt_first_name SHOULD be defined' do
            expect(@user1.respond_to?(:pt_first_name)).to be true
            expect(@user2.respond_to?(:pt_last_name)).to be true
          end

          it '#es_first_name SHOULD be defined' do
            expect(@user1.respond_to?(:es_first_name)).to be true
            expect(@user2.respond_to?(:es_last_name)).to be true
          end
        end
      end
    end
  end

  describe '#define_translation_methods' do
    context 'when the passed methods do not exist' do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations
        end

        LostInTranslations.define_translation_methods(@user_class, :unknown)

        @user = @user_class.new('Joao', 'Neve')
      end

      it '#unknown should be defined' do
        expect(@user.respond_to?(:unknown)).to be true
      end

      it '#<I18n.available_locales>_unknown should be defined' do
        I18n.available_locales.each do |locale|
          method_name = locale.to_s.downcase.tr('-', '_')

          expect(@user.respond_to?("#{method_name}_unknown")).to be true
        end
      end
    end

    context 'when the passed methods do exist' do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations
        end

        LostInTranslations.define_translation_methods(@user_class, :first_name)

        @user = @user_class.new('Joao', 'Neve')
      end

      it '#first_name should be defined' do
        expect(@user.respond_to?(:first_name)).to be true
      end

      it '#<I18n.available_locales>_first_name should be defined' do
        I18n.available_locales.each do |locale|
          method_name = locale.to_s.downcase.tr('-', '_')

          expect(@user.respond_to?("#{method_name}_first_name")).to be true
        end
      end
    end
  end

  describe '#included' do
    context 'when the object inherits from ActiveRecord' do
      before do
        @user_class = Class.new(ActiveRecord::Base) do
          self.table_name = 'users'

          include LostInTranslations
        end
      end

      it 'LostInTranslations::ActiveRecord must be included' do
        ancestors = @user_class.ancestors

        expect(ancestors.include?(LostInTranslations::ActiveRecord)).to be true
      end
    end

    context 'when the object DOES NOT inherit from ActiveRecord' do
      before do
        @user_class = Class.new { include LostInTranslations }
      end

      it 'LostInTranslations::Ruby must be included' do
        expect(@user_class.ancestors.include?(LostInTranslations::Ruby)).to \
          be true
      end
    end
  end

  describe '#translation_data' do
    context 'when the object.translation_data is nil' do
      before do
        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations

          translate :first_name

          attr_accessor :translation_data
        end

        @user = @user_class.new('joao', 'neve')
      end

      it 'should return an empty Hash' do
        expect(LostInTranslations.translation_data(@user)).to eq({})
        expect(@user.translation_data).to eq({})
      end
    end

    context 'setting the #config.translation_data_field to a known method' do
      before do
        LostInTranslations.configure do |config|
          config.translation_data_field = 'translation_json'
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations

          translate :first_name

          def translation_json
            { 'en-GB' => { first_name: 'Jon', last_name: 'Snow' } }
          end
        end

        @user = @user_class.new('joao', 'neve')
      end
      after do
        LostInTranslations.config.translation_data_field = 'translation_data'
      end

      it 'should return the known method results' do
        expect(LostInTranslations.translation_data(@user)).to eq(
          'en-GB' => { first_name: 'Jon', last_name: 'Snow' }
        )
      end
    end

    context 'setting the #config.translation_data_field to an unknown method' do
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
      after do
        LostInTranslations.config.translation_data_field = 'translation_data'
      end

      it 'should raise an error' do
        expect { LostInTranslations.translation_data(@user) }.to \
          raise_error(NotImplementedError)
      end
    end

    context 'when changing the #config.fallback_to_default_locale' do
      before do
        LostInTranslations.configure do |config|
          config.fallback_to_default_locale = true
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations::Ruby

          translate :first_name

          def translation_data
            @translation_data ||= {
              'en-GB' => { first_name: 'Jon' },
              'fr' => { first_name: 'Jean' }
            }
          end
        end

        @user = @user_class.new('Joao', 'Neve')
      end
      after do
        LostInTranslations.config.fallback_to_default_locale = nil
      end

      it 'empty translations should return the default locale entry' do
        expect(@user.de_first_name).to eq 'Joao'
      end
    end

    context 'when changing the #config.translator' do
      before do
        LostInTranslations.configure do |config|
          config.translator = Class.new(LostInTranslations::Translator::Base) do
            def self.translation_data(_)
              { 'en-GB' => { first_name: 'Jon', last_name: 'Snow' } }
            end
          end
        end

        @user_class = Struct.new(:first_name, :last_name) do
          include LostInTranslations

          translate :first_name
        end

        @user = @user_class.new('joao', 'neve')
      end
      after do
        LostInTranslations.config.translator =
          LostInTranslations::Translator::Base
      end

      it 'should return the known method results' do
        expect(LostInTranslations.translation_data(@user)).to eq(
          'en-GB' => { first_name: 'Jon', last_name: 'Snow' }
        )
      end
    end
  end
end
