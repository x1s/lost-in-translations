# Lost In Translations
Super light Translation Ruby Gem agnostic to your framework and source data

[![Code Climate](https://codeclimate.com/github/Streetbees/lost-in-translations/badges/gpa.svg)](https://codeclimate.com/github/Streetbees/lost-in-translations)
[![Test Coverage](https://codeclimate.com/github/Streetbees/lost-in-translations/badges/coverage.svg)](https://codeclimate.com/github/Streetbees/lost-in-translations/coverage)
[![Build Status](https://travis-ci.org/Streetbees/lost-in-translations.svg?branch=master)](https://travis-ci.org/Streetbees/lost-in-translations)
[![Gem Version](https://badge.fury.io/rb/lost_in_translations.svg)](https://badge.fury.io/rb/lost_in_translations)

## 1) Basic Usage
```ruby
class User < Struct.new(:title, :first_name, :last_name)
  include LostInTranslations

  translate :title, :first_name

  def translation_data
    @translation_data ||= {
      en: { first_name: 'Jon', last_name: 'Snow' },
      fr: { first_name: 'Jean', last_name: 'Neige' }
    }
  end
end
```
Class method ```.translate``` will redefine ```#title``` and ```#first_name``` instance methods in order to return the values that match the ```I18n.locale``` and the ```attribute name``` from the Hash returned by ```#translation_data```.

```ruby
@user = User.new('Cavaleiro', 'Joao', 'Neve')

I18n.default_locale = :pt
I18n.locale = :fr

@user.first_name # returns 'Jean'
@user.last_name # returns 'Neve'
@user.title # returns nil

I18n.with_locale(:en) do
  @user.first_name # returns 'Jon'
  @user.last_name # returns 'Neve'
  @user.title # returns nil
end

I18n.with_locale(:pt) do
  # there is no translation present but since locale
  # matches the default_locale, the original value is returned

  @user.first_name # returns 'Joao'
  @user.last_name # returns 'Neve'
  @user.title # returns 'Cavaleiro'
end

I18n.with_locale(:de) do
  @user.first_name # returns nil
  @user.last_name # returns 'Neve'
  @user.title # returns nil
end
```

The following instance methods are also available:
#### 1.1) ```#translate```
```ruby
@user.translate(:first_name, :fr) # returns 'Jean'
@user.translate(:first_name, :en) # returns 'Jon'
@user.translate(:first_name, :pt) # returns 'Joao'
@user.translate(:first_name, :de) # returns nil
```

#### 1.2) ```#<I18n.available_locales>_<translated_field>```
```ruby
@user.fr_first_name # returns 'Jean'
@user.en_first_name # returns 'Jon'
@user.pt_first_name # returns 'Joao'
@user.de_first_name # returns nil
```

#### 1.3) ```#<I18n.available_locales>_<translated_field>=```
```ruby
@user.pt_first_name = 'João'
@user.de_first_name = 'Hans'

@user.translation_data  # will contain
                        # {
                        #   en: { first_name: 'Jon', last_name: 'Snow' },
                        #   pt: { first_name: 'João' },
                        #   de: { first_name: 'Hans' },
                        #   fr: { first_name: 'Jean', last_name: 'Neige' }
                        # }
```

## 2) Ideal usage
If your ActiveRecord Model has a json attribute called ```translation_data```.
```ruby
class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.jsonb :translation_data
      t.timestamps
    end

    User.create \
      title: 'Cavaleiro',
      first_name: 'Joao',
      last_name: 'Neve',
      translation_data: {
        en: { first_name: 'Jon', last_name: 'Snow' },
        fr: { first_name: 'Jean', last_name: 'Neige' }
      }
  end
end
```

The usage becomes quite simple.
```ruby
class User < ActiveRecord::Base
  include LostInTranslations

  translate :title, :first_name
end

@user = User.find(1)

I18n.locale = :fr

@user.first_name # returns 'Jean'
@user.last_name # returns 'Neve'
@user.title # returns nil
```

## 3) Forcing locales

There are many cases when you'll need to translate only a part of your data,
specially if this part is returned in a list of translated data.

For those cases you only have to define the field (virtual or persisted)
`force_locale` with one valid locale:

```ruby
class User < ActiveRecord::Base
  include LostInTranslations

  translate :title, :first_name
end

User.create(
  title: 'Cavaleiro',
  first_name: 'Joao',
  last_name: 'Neve',
  force_locale: nil,
  translation_data: {
    en: { first_name: 'Jon', last_name: 'Snow' },
    fr: { first_name: 'Jean', last_name: 'Neige' }
  }
)

User.create(
  title: 'Cavaleiro',
  first_name: 'Joao',
  last_name: 'Neve',
  force_locale: 'fr'
  translation_data: {
    en: { first_name: 'Jon', last_name: 'Snow' },
    fr: { first_name: 'Jean', last_name: 'Neige' }
  }
)

User.create(
  title: 'Cavaleiro',
  first_name: 'Joao',
  last_name: 'Neve',
  force_locale: 'en'
  translation_data: {
    en: { first_name: 'Jon', last_name: 'Snow' },
    fr: { first_name: 'Jean', last_name: 'Neige' }
  }
)

I18n.locale = :pt

User.all.each do |user|
  puts user.name
end

# It'll automatically output:
# Joao
# Jean
# Jon

```


## 4) Instalation

Add this to your Gemfile:
```
gem 'lost_in_translations'
```

And then execute:

```
$> bundle install
```

In Rails, create the file **config/initializers/lost_in_translations.rb** with:
```ruby
LostInTranslations.reload
```
Because Rails starts with a set of **I18n.available_locales** different from when it finished loading and **LostInTranslations** needs to redefine new methods for those new locales in your classes.

## 5) F.A.Q.

- [I18n.available_locales as changed, how do I recreate the new translation methods?](https://github.com/Streetbees/lost-in-translations/wiki/Redefining-translation-methods)
- [Your "translation_data" method (in all of your objects) is not called "translation_data"](https://github.com/Streetbees/lost-in-translations/wiki/translation_data-configuration-version-1)
- [Your "translation_data" method (in a particular object) is not called "translation_data"](https://github.com/Streetbees/lost-in-translations/wiki/translation_data-configuration-version-2)
- [Custom translation mechanism](https://github.com/Streetbees/lost-in-translations/wiki/Custom-translation-mechanism)
