# Changelog

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
