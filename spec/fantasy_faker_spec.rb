# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasyFaker do
  after do
    described_class.reset_locale
  end

  describe '.locale' do
    subject(:locale) { described_class.locale }

    it 'returns :en by default' do
      expect(locale).to eq(:en)
    end

    context 'when I18n is defined' do
      let(:i18n_stub) { Class.new { class << self; attr_accessor :locale; end } }

      before do
        stub_const('I18n', i18n_stub)
      end

      it 'uses I18n.locale when supported' do
        I18n.locale = :pl
        expect(locale).to eq(:pl)
      end

      it 'normalizes string locale from I18n.locale' do
        I18n.locale = 'pl'
        expect(locale).to eq(:pl)
      end

      it 'maps regional locales like pl_PL, pl-PL, en_GB, en-US to base language' do
        I18n.locale = :pl_PL
        expect(described_class.locale).to eq(:pl)

        I18n.locale = 'pl-PL'
        expect(described_class.locale).to eq(:pl)

        I18n.locale = :en_GB
        expect(described_class.locale).to eq(:en)

        I18n.locale = 'en-US'
        expect(described_class.locale).to eq(:en)
      end

      it 'falls back to :en when I18n.locale is not supported' do
        I18n.locale = :de
        expect(locale).to eq(:en)
      end

      it 'prefers forced locale via .use_locale over I18n.locale' do
        I18n.locale = :en
        described_class.use_locale(:pl)

        expect(locale).to eq(:pl)
      end
    end

    context 'when locale is forced with .use_locale' do
      it 'returns the forced locale when supported' do
        described_class.use_locale('pl')
        expect(locale).to eq(:pl)
      end

      it 'maps regional forced locales like pl_PL or en_GB to base language' do
        described_class.use_locale(:pl_PL)
        expect(described_class.locale).to eq(:pl)

        described_class.use_locale('en_GB')
        expect(described_class.locale).to eq(:en)
      end

      it 'falls back to :en when forced locale is unsupported' do
        described_class.use_locale(:es)
        expect(locale).to eq(:en)
      end

      it 'clears forced locale when nil is passed' do
        described_class.use_locale(:pl)
        described_class.use_locale(nil)

        expect(locale).to eq(:en)
      end

      it 'supports a temporary locale within a block and restores previous locale' do
        described_class.use_locale(:en)

        described_class.use_locale(:pl) do
          expect(described_class.locale).to eq(:pl)
        end

        expect(locale).to eq(:en)
      end
    end
  end
end
