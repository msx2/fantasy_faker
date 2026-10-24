# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasyFaker::Character do
  after do
    FantasyFaker.reset_locale
  end

  describe '.unique' do
    let(:common_data) do
      {
        'name_prefixes_male' => ['Ar'], 'name_sufixes_male' => ['ion'],
        'name_prefixes_female' => ['El'], 'name_sufixes_female' => ['ara']
      }.transform_values { |values| FantasyFaker::ArrayUtils.const_array(values) }
    end

    let(:locale_data) do
      {
        'nicknames_male' => ['the Bold'], 'nicknames_female' => ['the Bold']
      }.transform_values { |values| FantasyFaker::ArrayUtils.const_array(values) }
    end

    before do
      allow(described_class).to receive_messages(common_data: common_data, locale_data: locale_data)
    end

    after { described_class.unique.clear }

    {
      male_first_name: ['Arion'], female_first_name: ['Elara'],
      male_nickname: ['the Bold'], female_nickname: ['the Bold'],
      male_name: ['Arion', 'Arion the Bold'], female_name: ['Elara', 'Elara the Bold']
    }.each do |method, values|
      it "returns distinct #{method} values and raises when exhausted" do
        generated = Array.new(values.size) { described_class.unique.public_send(method) }

        expect(generated).to match_array(values)
        expect { described_class.unique.public_send(method) }
          .to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
      end
    end

    it 'tracks each generation method independently' do
      expect(described_class.unique.male_nickname).to eq('the Bold')
      expect(described_class.unique.female_nickname).to eq('the Bold')
    end

    it 'stops after exactly 10,000 unsuccessful attempts' do
      described_class.unique.male_nickname
      allow(described_class).to receive(:male_nickname).and_call_original

      expect { described_class.unique.male_nickname }
        .to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
      expect(described_class).to have_received(:male_nickname).exactly(10_000).times
    end

    it 'clears history for every method so values can be reused' do
      described_class.unique.male_nickname
      described_class.unique.female_first_name
      described_class.unique.clear

      expect(described_class.unique.male_nickname).to eq('the Bold')
      expect(described_class.unique.female_first_name).to eq('Elara')
    end

    it 'leaves ordinary generation unchanged' do
      described_class.unique.male_nickname

      expect(Array.new(2) { described_class.male_nickname }).to eq(['the Bold', 'the Bold'])
    end

    it 'preserves history when the locale changes' do
      described_class.unique.male_nickname
      FantasyFaker.use_locale(:pl)

      expect { described_class.unique.male_nickname }
        .to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
    end

    it 'reports supported generator methods' do
      expect(described_class.unique).to respond_to(:male_name, :female_name)
      expect(described_class.unique).not_to respond_to(:unknown_generator)
    end

    it 'raises NoMethodError for unknown methods' do
      unique = described_class.unique

      expect { unique.unknown_generator }.to raise_error(NoMethodError)
    end
  end

  { male: 4998, female: 2760 }.each do |gender, minimum_names|
    describe "#{gender} first-name combinations" do
      let(:first_names) do
        prefixes = described_class.fetch_data("name_prefixes_#{gender}")
        suffixes = described_class.fetch_data("name_sufixes_#{gender}")
        prefixes.product(suffixes).map(&:join).uniq
      end

      it 'provides at least twice the original number of distinct names' do
        expect(first_names.size).to be >= minimum_names
      end

      it 'does not contain the known vulgar stems in any combination' do
        expect(first_names.grep(/dildo|milf/i)).to be_empty
      end
    end
  end

  { en: { male: 300, female: 300 }, pl: { male: 298, female: 296 } }.each do |locale, minimums|
    minimums.each do |gender, minimum_nicknames|
      it "provides at least twice the original number of distinct #{locale} #{gender} nicknames" do
        nicknames = FantasyFaker.use_locale(locale) { described_class.fetch_data("nicknames_#{gender}") }

        expect(nicknames.uniq.size).to be >= minimum_nicknames
      end
    end
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
