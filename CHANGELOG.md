# Changelog

## 0.3.0 - October 24, 2026

- Add `.unique` to all character name and nickname generators, with per-method tracking across locale changes.
- Raise `FantasyFaker::UniqueGenerator::RetryLimitExceeded` after 10,000 unsuccessful attempts to generate a new value.
- Add `FantasyFaker::Character.unique.clear` to reset uniqueness tracking.

## 0.2.0 - October 21, 2026

- Expand the first-name dictionaries from 2,499 to 5,040 distinct male names and from 1,380 to 2,795 distinct female names.
- Add 150 fantasy-themed nicknames per gender in both English and Polish, with matching translations.
- Replace the male prefixes that produced `Dildonar` and `Amilfreano`.
- Sort all name prefixes, suffixes, and nicknames alphabetically.

## 0.1.0 - October 16, 2026

- Require Ruby 3.0+
- Add support for `:en` (default) and `:pl` locales, with automatic detection from `I18n.locale` and regional locale mapping (e.g. `en_GB`, `en-US`, `pl_PL`)
- Add `FantasyFaker.use_locale` (global and block form) and `FantasyFaker.reset_locale`
- Add English male and female character nickname dictionaries
- Migrate dictionary files to YAML under `locales/`
- Add RuboCop configuration and GitHub Actions CI workflow

## 0.0.3 - January 5, 2015

- Update `FantasyFaker::Character` name and nickname generation methods

## 0.0.2 - January 3, 2015

- Update gem description and metadata

## 0.0.1 - January 2, 2015

- Initial release with `FantasyFaker::Character` and Polish character dictionaries
