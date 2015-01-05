require 'spec_helper'

describe FantasyFaker::Character do

  describe '#male_first_name' do
    subject { described_class.male_first_name }

    it { is_expected.to match(/[a-z]+/i) }
  end

  describe '#male_nickname' do
    subject { described_class.male_nickname }

    it { is_expected.to match(/[ a-zęóąśłżźćń]+/i) }
  end

  describe '#male_name' do
    subject { described_class.male_name }

    it { is_expected.to match(/[ a-zęóąśłżźćń]+/i) }
  end

  describe '#female_first_name' do
    subject { described_class.female_first_name }

    it { is_expected.to match(/[a-z]+/i) }
  end

  describe '#female_nickname' do
    subject { described_class.female_nickname }

    it { is_expected.to match(/[ a-zęóąśłżźćń]+/i) }
  end

  describe '#female_name' do
    subject { described_class.female_name }

    it { is_expected.to match(/[ a-zęóąśłżźćń]+/i) }
  end

end
