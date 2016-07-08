shared_examples_for "a basic usage" do
  it "should behave like the readme says" do
    I18n.default_locale = :pt
    I18n.locale = :fr

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

  context "when making use of setter translation methods" do
    before do
      @user.pt_first_name = 'João'
      @user.de_first_name = 'Hans'
    end

    it "#translation_data should be updated" do
      expect(@user.translation_data).to eq ({
        en: { first_name: 'Jon', last_name: 'Snow' },
        pt: { first_name: 'João' },
        de: { first_name: 'Hans' },
        fr: { first_name: 'Jean', last_name: 'Neige' }
      })
    end

    it "translation method should return the updated results" do
      expect(@user.translate(:first_name, :fr)).to eq 'Jean'
      expect(@user.translate(:first_name, :en)).to eq 'Jon'
      expect(@user.translate(:first_name, :pt)).to eq 'João'
      expect(@user.translate(:first_name, :de)).to eq 'Hans'
    end
  end
end
