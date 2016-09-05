require 'spec_helper'

describe LostInTranslations::ActiveRecord do
  context 'when building a resource' do
    before do
      @user_class = Class.new(ActiveRecord::Base) do
        self.table_name = 'users'

        include LostInTranslations::ActiveRecord

        translate :title, :first_name

        def translation_data
          @translation_data ||= {
            'en-GB' => { first_name: 'Jon', last_name: 'Snow' },
            'fr' => { first_name: 'Jean', last_name: 'Neige' }
          }
        end
      end

      @user = @user_class.new \
        title: 'Cavaleiro',
        first_name: 'Joao',
        last_name: 'Neve'
    end

    it_behaves_like 'the readme example'
  end

  context 'When finding a resource' do
    before do
      @user_class = Class.new(ActiveRecord::Base) do
        self.table_name = 'users'

        include LostInTranslations::ActiveRecord

        translate :title, :first_name

        def translation_data
          @translation_data ||= {
            'en-GB' => { first_name: 'Jon', last_name: 'Snow' },
            'fr' => { first_name: 'Jean', last_name: 'Neige' }
          }
        end
      end

      @user = @user_class.first
    end

    it_behaves_like 'the readme example'
  end
end
