[![Codeship Status for msx2/fantasy_faker](https://codeship.com/projects/367f3fe0-7500-0132-c61e-22ab3bab314c/status?branch=master)](https://codeship.com/projects/55108)

# FantasyFaker

Inspired by [ffaker](https://github.com/EmmanuelOga/ffaker), used to easily generate fake random data: e.g. name, nickname.

Created on a sole purpose to be used in fantasy-climate projects. Currently supports only Polish language.

## Installation

Add this line to your application's Gemfile:

```
gem 'fantasy_faker'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install fantasy_faker
```

## Usage

```ruby
require 'fantasy_faker'

FantasyFaker::Character.male_name => "Sarillon"
FantasyFaker::Character.male_nickname => "Dziecię Pustyni"
FantasyFaker::Character.male_full_name => "Aemanti Lepka Dłoń"

FantasyFaker::Character.female_name => "Linani"
FantasyFaker::Character.female_nickname => "Wstydliwa"
FantasyFaker::Character.female_full_name => "Setaris Krwawa Klinga"
```    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request