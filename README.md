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

### Locations

`FantasyFaker::Location` uses a shared pool of 1,000 invented proper names across
16 categories, with English (`:en`) and Polish (`:pl`) landmark descriptions:

Cities return the proper name alone. Other categories combine it with a localized
landmark type and optional prefixes or suffixes, mixing neutral and dark fantasy styles:
`Alador Forest`, `Dark Alador Forest`, `Las Alador` or `Puszcza Alador Czarnych Cierni`.
Proper names are shared between locales; changing language changes the description,
not the underlying proper-name pool.

| Method | Category |
| --- | --- |
| `city` | Cities |
| `sewer` | Urban sewers |
| `meadow` | Meadows and wetlands |
| `forest` | Forests |
| `swamp` | Swamps |
| `waters` | Rivers and lakes |
| `desert` | Deserts and dunes |
| `cave` | Caves |
| `mine` | Mines |
| `mountain` | Mountains |
| `volcanic_field` | Volcanic fields |
| `ruins` | Ruins |
| `stronghold` | Strongholds |
| `graveyard` | Graveyards |
| `abandoned_monastery` | Abandoned monasteries |
| `labyrinth_or_arena` | Labyrinths and arenas |

Use `name` to choose a random category and generate a name from it:

```ruby
FantasyFaker::Location.city # => "Alador"
FantasyFaker::Location.forest # => "Dark Alador Forest"
FantasyFaker::Location.name # => a name from any location category

FantasyFaker.use_locale(:pl) do
  FantasyFaker::Location.city # => "Alador"
  FantasyFaker::Location.forest # => "Mroczny Las Alador"
  FantasyFaker::Location.waters # => "Jezioro Alador Zatopionych Dzwonów"
end
```

### Unique values

Use `.unique` with any character or location generator.

```ruby
FantasyFaker::Character.unique.male_name
FantasyFaker::Character.unique.female_nickname
FantasyFaker::Location.unique.city
FantasyFaker::Location.unique.name

# Reset all character generators' uniqueness history (for example, between tests)
FantasyFaker::Character.unique.clear

# Location history is separate from character history
FantasyFaker::Location.unique.clear
```

In FactoryBot (formerly FactoryGirl), use it inside the attribute block:

```ruby
factory :character do
  name { FantasyFaker::Character.unique.male_name }
end

factory :location do
  name { FantasyFaker::Location.unique.forest }
end
```

Character generators track values separately for each method. Location generators share
one proper-name history across **all categories, `.name`, and both locales**. For example,
after `.unique.city` returns `Alador`, no other unique location generator can return
`Las Alador`, `Dark Alador Forest` or any other variant containing that proper name.
Prefixes and suffixes do not count as new proper names.

Character and location histories are separate. Ordinary calls without `.unique` are not
tracked and can still reuse names. Tracking happens within the current Ruby process;
it does not check existing database records or coordinate separate processes.

If no new value is found after 10,000 attempts, generation raises
`FantasyFaker::UniqueGenerator::RetryLimitExceeded` rather than returning a duplicate.
Because generation is random, this can happen before every possible value has been used.
The shared location pool contains 1,000 proper names in total, not 1,000 per category
or language. Use `FantasyFaker::Location.unique.clear` between tests when names can be reused;
this resets the history for all location categories at once.

## Development

Dictionary data is stored in YAML files under `locales/`:
- `locales/common.yml`: language-independent character name components (`character:`) and location proper names (`location:`)
- `locales/en/<module>.yml`: English entries for a module
- `locales/pl/<module>.yml`: Polish entries for a module

Location locale files contain templates with a single `%{name}` placeholder, including
neutral landmark types and dark fantasy prefixes and suffixes.

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
