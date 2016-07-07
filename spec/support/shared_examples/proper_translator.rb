shared_examples_for "a proper translator" do
  it "#field must return a translation" do
    I18n.with_locale(:en) do
      expect(@user.first_name).to eq 'Jon'
    end
  end

  context "when the translation data doesn't contain the desired language" do
    it "#field must return the original data" do
      I18n.with_locale(:de) do
        expect(@user.first_name).to eq 'Joao'
      end
    end
  end

  context "when the translation data doesn't contain the desired field" do
    it "#field must return the original data" do
      I18n.with_locale(:en) do
        expect(@user.title).to eq 'Cavaleiro'
      end
    end
  end
end