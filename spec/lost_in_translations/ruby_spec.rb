require 'spec_helper'

describe LostInTranslations::Ruby do

  context "when building a resource" do
    before do
      @user_class = Struct.new(:title, :first_name, :last_name) do
        include LostInTranslations::Ruby

        translate :title, :first_name

        def translation_data
          @translation_data ||= {
            en: { first_name: 'Jon', last_name: 'Snow' },
            fr: { first_name: 'Jean', last_name: 'Neige' }
          }
        end
      end

      @user = @user_class.new('Cavaleiro', 'Joao', 'Neve')
    end

    it_behaves_like "the readme example"
  end

end
