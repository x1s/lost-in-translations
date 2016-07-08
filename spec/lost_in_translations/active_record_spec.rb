require 'spec_helper'

describe LostInTranslations::ActiveRecord do

  describe 'readme example' do
    context "basic usage" do
      before do
        @user_class = Class.new(ActiveRecord::Base) do
          self.table_name = 'users'

          include LostInTranslations::ActiveRecord

          translate :title, :first_name

          def translation_data
            @translation_data ||= {
              en: { first_name: 'Jon', last_name: 'Snow' },
              fr: { first_name: 'Jean', last_name: 'Neige' }
            }
          end
        end

        @user = @user_class.new(title: 'Cavaleiro', first_name: 'Joao', last_name: 'Neve')
      end

      it_behaves_like "a basic usage"
    end
  end

  # describe '.translate' do
  #
  #   context "when translating a field" do
  #     before do
  #       @user_class = Class.new(ActiveRecord::Base) do
  #         self.table_name = 'users'
  #
  #         include LostInTranslations::ActiveRecord
  #
  #         translate :title, :first_name
  #
  #         def translation_data
  #           @translation_data ||= {
  #             en: { first_name: 'Jon', last_name: 'Snow' },
  #             fr: { first_name: 'Jean', last_name: 'Neige' }
  #           }
  #         end
  #       end
  #
  #       # @user_class.create title: 'Cavaleiro', first_name: 'Joao', last_name: 'Neve'
  #       @user = @user_class.first
  #     end
  #     # after { @user.destroy }
  #
  #     it_behaves_like "a proper translator"
  #   end
  #
  #   context "when a particular field is not translated" do
  #     before do
  #       @user_class = Class.new(ActiveRecord::Base) do
  #         self.table_name = 'users'
  #
  #         include LostInTranslations::ActiveRecord
  #
  #         translate :title, :first_name
  #
  #         def translation_data
  #           @translation_data ||= {
  #             en: { first_name: 'Jon', last_name: 'Snow' },
  #             fr: { first_name: 'Jean', last_name: 'Neige' }
  #           }
  #         end
  #       end
  #
  #       @user = @user_class.new title: 'Cavaleiro', first_name: 'Joao', last_name: 'Neve'
  #     end
  #
  #     it "#field must return the original data" do
  #       I18n.with_locale(:en) do
  #         expect(@user.last_name).to eq 'Neve'
  #       end
  #     end
  #   end
  #
  # end

end
