require 'spec_helper'

describe LostInTranslation::Base do

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

      it "must return a translation" do
        expect(@user.translate(:first_name, :en)).to eq 'Jon'
      end

      context "and the translation data doesn't contain results" do
        it "must return the original data" do
          expect(@user.translate(:first_name, :fr)).to eq 'joao'
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

      it "MUST return a translation" do
        expect(@user.translate(:last_name, :en)).to eq 'Snow'
      end

      context "and the translation data doesn't contain results" do
        it "must return the original data" do
          expect(@user.translate(:first_name, :fr)).to eq 'joao'
        end
      end
    end

  end

end
