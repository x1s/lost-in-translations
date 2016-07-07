# Lost In Translations
Super light Translation Ruby Gem agnostic to your framework and source data

[![Code Climate](https://codeclimate.com/github/Streetbees/lost_in_translations/badges/gpa.svg)](https://codeclimate.com/github/Streetbees/lost_in_translations)
[![Test Coverage](https://codeclimate.com/github/Streetbees/lost_in_translations/badges/coverage.svg)](https://codeclimate.com/github/Streetbees/lost_in_translations/coverage)
[![Build Status](https://travis-ci.org/Streetbees/lost_in_translations.svg?branch=master)](https://travis-ci.org/Streetbees/lost_in_translations)

## 1. Basic Usage
```ruby
class User < Struct.new(:title, :first_name, :last_name)
  include LostInTranslations

  translate :title, :first_name

  def translation_data
    {
      en: { first_name: 'Jon', last_name: 'Snow' },
      fr: { first_name: 'Jean', last_name: 'Neige' }
    }
  end
end
```
Class method **.translate** will redefine **#title** and **#first_name** instance methods in order to return the values that match the **I18n.locale** and the **attribute name** from the Hash returned by **#translation_data**, otherwise calls the original redefined method.

```ruby
@user = User.new('Cavaleiro', 'Joao', 'Neve')

I18n.locale = :fr

@user.first_name # returns 'Jean'
@user.last_name # returns 'Neve'
@user.title # returns 'Cavaleiro'

I18n.with_locale(:en) do
  @user.first_name # returns 'Jon'
  @user.last_name # returns 'Neve'
  @user.title # returns 'Cavaleiro'
end

I18n.with_locale(:de) do
  @user.first_name # returns 'Joao'
  @user.last_name # returns 'Neve'
  @user.title # returns 'Cavaleiro'
end
```

Instance method **#translate** is also available:
```ruby
@user.translate(:first_name, :fr) # returns 'Jean'
@user.translate(:first_name, :en) # returns 'Jon'
@user.translate(:first_name, :de) # returns 'Joao'
```

## 2. Ideal usage
If your ActiveRecord Model has a json attribute called **translation_data**.
```ruby
class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.json :translation_data
      t.timestamps
    end

    User.create \
      title: 'Cavaleiro',
      first_name: 'Joao',
      last_name: 'Neve'
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
@user.title # returns 'Cavaleiro'
```

## 3. Configuration

### 3.1 Your "translation_data" method (in all of your objects) is not called "translation_data"
```ruby
LostInTranslations.configure do |config|
  config.translation_data_field = 'my_translation_data_field'
end
```

```ruby
class User < ActiveRecord::Base
  include LostInTranslations

  translate :first_name

  def my_translation_data_field
    {
      en: { first_name: 'Jon', last_name: 'Snow' },
      fr: { first_name: 'Jean', last_name: 'Neige' }
    }
  end
end

I18n.locale = :fr

User.find(1).first_name # returns 'Jean'
```

### 3.2 Your "translation_data" method (in a particular object) is not called "translation_data"
```ruby
class User < ActiveRecord::Base
  include LostInTranslations

  translate :first_name

  self.translation_data_field = :my_translation_data_field

  def my_translation_data_field
    {
      en: { first_name: 'Jon', last_name: 'Snow' },
      fr: { first_name: 'Jean', last_name: 'Neige' }
    }
  end
end

I18n.locale = :fr

User.find(1).first_name # returns 'Jean'
```

### 3.3 Custom translation mechanism
```ruby
class MyTranslator
  def self.translate(object, field, locale)
    translations = #get_data_from_redis_or_yaml_file(object)

    (translations[locale] || {})[field]
  end
end
```

```ruby
LostInTranslations.configure do |config|
  config.translator = MyTranslator
end
```

```ruby
class User < ActiveRecord::Base
  include LostInTranslations

  translate :first_name
end

I18n.locale = :fr

User.find(1).first_name # returns 'Jean' from redis or yaml file
```

Don't forget that you can do the same at the object level
```ruby
class User < ActiveRecord::Base
  include LostInTranslations

  translate :first_name

  def translation_data
    # get_data_from_redis_or_yaml_file(self)
  end
end

I18n.locale = :fr

User.find(1).first_name # returns 'Jean' from redis or yaml file
```

## 4 Instalation

Add your application's Gemfile:
```
gem 'lost_in_translations'
```

And then execute:

```
$> bundle install
```
