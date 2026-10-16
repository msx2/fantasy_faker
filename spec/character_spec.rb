# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasyFaker::Character do
  after do
    FantasyFaker.reset_locale
  end

  describe '#male_first_name' do
    subject(:male_first_name) { described_class.male_first_name }

    it { is_expected.to match(/\A[a-z]+\z/i) }
  end

  describe '#male_nickname' do
    subject(:male_nickname) { described_class.male_nickname }

    it { is_expected.to match(/\A[ a-z]+\z/i) }

    context 'when locale is :pl' do
      before { FantasyFaker.use_locale(:pl) }

      it 'returns a Polish nickname' do
        expect(described_class.fetch_data(:nicknames_male)).to include(male_nickname)
      end
    end

    context 'when locale is :en' do
      before { FantasyFaker.use_locale(:en) }

      it 'returns an English nickname' do
        expect(described_class.fetch_data(:nicknames_male)).to include(male_nickname)
      end
    end

    it 'switches nicknames dynamically when locale changes' do
      en_nicknames = FantasyFaker.use_locale(:en) { described_class.fetch_data(:nicknames_male) }
      pl_nicknames = FantasyFaker.use_locale(:pl) { described_class.fetch_data(:nicknames_male) }

      FantasyFaker.use_locale(:en)
      expect(en_nicknames).to include(described_class.male_nickname)

      FantasyFaker.use_locale(:pl)
      expect(pl_nicknames).to include(described_class.male_nickname)
    end
  end

  describe '#male_name' do
    subject(:male_name) { described_class.male_name }

    it { is_expected.to match(/\A[ a-z]+\z/i) }

    context 'when locale is :pl' do
      before { FantasyFaker.use_locale(:pl) }

      it { is_expected.to match(/\A[ a-zęóąśłżźćń]+\z/i) }
    end
  end

  describe '#female_first_name' do
    subject(:female_first_name) { described_class.female_first_name }

    it { is_expected.to match(/\A[a-z]+\z/i) }
  end

  describe '#female_nickname' do
    subject(:female_nickname) { described_class.female_nickname }

    it { is_expected.to match(/\A[ a-z]+\z/i) }

    context 'when locale is :pl' do
      before { FantasyFaker.use_locale(:pl) }

      it 'returns a Polish nickname' do
        expect(described_class.fetch_data(:nicknames_female)).to include(female_nickname)
      end
    end

    context 'when locale is :en' do
      before { FantasyFaker.use_locale(:en) }

      it 'returns an English nickname' do
        expect(described_class.fetch_data(:nicknames_female)).to include(female_nickname)
      end
    end
  end

  describe '#female_name' do
    subject(:female_name) { described_class.female_name }

    it { is_expected.to match(/\A[ a-z]+\z/i) }

    context 'when locale is :pl' do
      before { FantasyFaker.use_locale(:pl) }

      it { is_expected.to match(/\A[ a-zęóąśłżźćń]+\z/i) }
    end
  end
end
