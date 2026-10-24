[![Gem Version](https://badge.fury.io/rb/fantasy_faker.svg)](https://badge.fury.io/rb/fantasy_faker)

# FantasyFaker

Inspired by [ffaker](https://github.com/EmmanuelOga/ffaker), used to easily generate fake random data: e.g. name, nickname.

Created on a sole purpose to be used in fantasy-climate projects. Requires Ruby 3.0+. Supports English (`:en`, default) and Polish (`:pl`) locales.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fantasy_faker'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install fantasy_faker
```

## Usage

```ruby
require 'fantasy_faker'

# Default locale is :en (or read automatically from I18n.locale in Rails)
FantasyFaker::Character.male_first_name => "Sarillon"
FantasyFaker::Character.male_nickname => "Child of the Desert"
FantasyFaker::Character.male_name => "Sarillon Child of the Desert" # OR "Sarillon"

FantasyFaker::Character.female_first_name => "Linani"
FantasyFaker::Character.female_nickname => "the Bashful"
FantasyFaker::Character.female_name => "Linani the Bashful" # OR "Linani"

# Force a specific locale (globally or with a block)
FantasyFaker.use_locale(:pl)
FantasyFaker::Character.male_nickname => "Dziecię Pustyni"
FantasyFaker::Character.female_nickname => "Wstydliwa"

FantasyFaker.use_locale(:pl) do
  FantasyFaker::Character.male_name => "Sarillon Dziecię Pustyni"
end
```

### Unique values

Use `.unique` with any character generator: `male_first_name`, `female_first_name`,
`male_nickname`, `female_nickname`, `male_name`, or `female_name`.

```ruby
FantasyFaker::Character.unique.male_name
FantasyFaker::Character.unique.female_nickname

# Reset all character generators' uniqueness history (for example, between tests)
FantasyFaker::Character.unique.clear
```

In FactoryBot (formerly FactoryGirl), use it inside the attribute block:

```ruby
factory :character do
  name { FantasyFaker::Character.unique.male_name }
end
```

Values are tracked separately for each method within the current Ruby process,
including across locale changes. Ordinary calls without `.unique` are not tracked.
This does not check existing database records or coordinate separate processes.

If no new value is found after 10,000 attempts, generation raises
`FantasyFaker::UniqueGenerator::RetryLimitExceeded` rather than returning a duplicate.
Because generation is random, this can happen before every possible value has been used.

## Development

Dictionary data is stored in YAML files under `locales/`:
- `locales/common.yml`: language-independent lists (e.g. name prefixes and suffixes), grouped by module name (`character:`)
- `locales/en/<module>.yml`: English entries for a module
- `locales/pl/<module>.yml`: Polish entries for a module

```sh
bundle install
bundle exec rspec
bundle exec rubocop
bundle exec rake # both
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/msx2/fantasy_faker. When submitting changes, please make sure specs and RuboCop pass and document user-facing changes in [CHANGELOG.md](CHANGELOG.md).

## License

MIT, see [LICENSE.txt](LICENSE.txt).
