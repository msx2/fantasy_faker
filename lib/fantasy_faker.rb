# frozen_string_literal: true

require_relative 'fantasy_faker/version'
require_relative 'fantasy_faker/utils/array_utils'
require_relative 'fantasy_faker/unique_generator'
require_relative 'fantasy_faker/utils/base_module'
require_relative 'fantasy_faker/character'

module FantasyFaker
  DEFAULT_LOCALE = :en
  SUPPORTED_LOCALES = %i[en pl].freeze

  extend BaseModule

  ROOT_PATH = File.expand_path('../..', __FILE__)

  class << self
    def use_locale(locale)
      return @forced_locale = normalize_locale(locale) unless block_given?

      previous_locale = @forced_locale
      @forced_locale = normalize_locale(locale)
      yield
    ensure
      @forced_locale = previous_locale if block_given?
    end

    def reset_locale
      @forced_locale = nil
    end

    def locale
      candidate = @forced_locale || i18n_locale || DEFAULT_LOCALE
      SUPPORTED_LOCALES.include?(candidate) ? candidate : DEFAULT_LOCALE
    end

    private

    def i18n_locale
      return unless defined?(I18n) && I18n.respond_to?(:locale)

      normalize_locale(I18n.locale)
    end

    def normalize_locale(locale)
      return if locale.nil?

      base = locale.to_s.split(/[-_]/).first
      base&.downcase&.to_sym
    end
  end
end
