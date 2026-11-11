# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasyFaker::Location do
  subject(:generator) { described_class }

  categories = %i[
    city sewer meadow forest swamp waters desert cave mine mountain volcanic_field
    ruins stronghold graveyard abandoned_monastery labyrinth_or_arena
  ]
  combined_categories = {
    meadow: { en: [/Meadow|Pasture/, /Wetland|Floodplain/], pl: [/Łąka|Pastwisko/, /Mokradła|Trzcinowiska/] },
    waters: { en: [/River|Brook/, /Lake|Tarn/], pl: [/Rzeka|Potok/, /Jezioro|Staw/] },
    desert: { en: [/Desert/, /Dunes/], pl: [/Pustynia/, /Wydmy/] },
    labyrinth_or_arena: { en: [/Labyrinth|Maze/, /Arena|Colosseum/], pl: [/Labirynt/, /Arena|Koloseum/] }
  }

  let(:proper_names) do
    YAML.safe_load_file("#{FantasyFaker::ROOT_PATH}/locales/common.yml").dig('location', 'proper_names') || []
  end

  # Build the shared-name lookup before an example can stub the name pool.
  before { generator.unique.clear }

  after do
    FantasyFaker.reset_locale
    generator.unique.clear
    FantasyFaker::Character.unique.clear
  end

  it 'provides 1000 distinct invented proper names, not decorative variants of the same name' do
    expect(proper_names.size).to eq(1000)
    expect(proper_names.map(&:downcase).uniq.size).to eq(1000)
    expect(proper_names).to all(match(/\A[A-Z][a-z]{3,10}\z/))
    expect(proper_names).not_to include('Vackell', 'Krotos', 'Grist', 'Kartusan', 'Erfalast')
  end

  %i[en pl].each do |locale|
    context "with #{locale} locale" do
      let(:dictionary) { YAML.safe_load_file("#{FantasyFaker::ROOT_PATH}/locales/#{locale}/location.yml") }

      before { FantasyFaker.use_locale(locale) }

      categories.each do |category|
        describe ".#{category}" do
          let(:templates) { dictionary.fetch(category.to_s) }
          let(:possible_names) do
            templates.flat_map { |template| proper_names.map { |name| template % { name: name } } }
          end

          it 'defines nonblank localized templates containing exactly one proper name' do
            expect(templates).not_to be_empty
            expect(templates).to all(be_a(String).and(match(/\A\S(?:.*\S)?\z/)))
            expect(templates.map { |template| template.scan('%{name}').size }).to all(eq(1))
          end

          it 'can represent all 1000 proper names in each decorative variant' do
            templates.each do |template|
              expect(proper_names.map { |name| template % { name: name } }.uniq.size).to eq(1000)
            end
          end

          it 'generates names from the matching localized templates and shared proper-name pool' do
            expect(possible_names).to include(generator.public_send(category))
          end

          it 'can select this category through .name' do
            stub_const('FantasyFaker::Location::CATEGORIES', [category])

            expect(possible_names).to include(generator.name)
          end
        end
      end

      it 'contains exactly the supported categories' do
        expect(dictionary.keys).to contain_exactly(
          'city', 'sewer', 'meadow', 'forest', 'swamp', 'waters', 'desert', 'cave',
          'mine', 'mountain', 'volcanic_field', 'ruins', 'stronghold', 'graveyard',
          'abandoned_monastery', 'labyrinth_or_arena'
        )
      end

      it 'returns bare proper names for cities' do
        expect(dictionary.fetch('city')).to eq(['%{name}'])
        expect(proper_names).to include(generator.city)
      end

      it 'mixes ordinary forests with dark forests, wildwoods and decorative suffixes' do
        patterns = if locale == :pl
                     [/\ALas %/, /\AMroczny Las %/, /\AMroczna Puszcza %/, /%\{name\} Czarnych Cierni\z/]
                   else
                     [/\A%\{name\} Forest\z/, /\ADark %\{name\} Forest/, /\ADark %\{name\} Wildwood/, /Black Thorns\z/]
                   end

        patterns.each { |pattern| expect(dictionary.fetch('forest').grep(pattern)).not_to be_empty }
      end

      combined_categories.each do |category, patterns|
        it "covers both location types in #{category}" do
          patterns.fetch(locale).each do |pattern|
            expect(dictionary.fetch(category.to_s).grep(pattern)).not_to be_empty
          end
        end
      end
    end
  end

  it 'switches localized landmark types immediately while retaining the same proper name' do
    root = proper_names.first
    fixed_names = FantasyFaker::ArrayUtils.const_array([root])
    allow(generator).to receive(:fetch_data).and_call_original
    allow(generator).to receive(:fetch_data).with(:proper_names).and_return(fixed_names)
    english = YAML.safe_load_file("#{FantasyFaker::ROOT_PATH}/locales/en/location.yml").fetch('forest')
    polish = YAML.safe_load_file("#{FantasyFaker::ROOT_PATH}/locales/pl/location.yml").fetch('forest')
    FantasyFaker.use_locale(:en)

    FantasyFaker.use_locale(:pl) do
      expect(polish.map { |template| template % { name: root } }).to include(generator.forest)
    end

    expect(english.map { |template| template % { name: root } }).to include(generator.forest)
  end

  it 'generates different proper names across real categories and locale changes with .unique' do
    methods = %i[city forest mine waters]
    generated = Array.new(200) do |index|
      FantasyFaker.use_locale(index.even? ? :en : :pl)
      generator.unique.public_send(methods[index % methods.size])
    end
    roots = generated.map { |name| proper_names.find { |root| name.split.include?(root) } }

    expect(roots).not_to include(nil)
    expect(roots.uniq.size).to eq(200)
  end

  describe '.unique' do
    let(:root) { proper_names.first }

    before do
      allow(generator).to receive_messages(
        city: root, forest: "Mroczny Las #{root}", mine: "Kopalnia #{root} Cieni"
      )
    end

    it 'reserves the proper name across different categories and decorative variants' do
      expect(generator.unique.city).to eq(root)

      expect { generator.unique.forest }.to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
      expect { generator.unique.mine }.to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
    end

    it 'skips a used proper name and retries until a different one is found' do
      other_root = proper_names.fetch(1)
      generator.unique.city
      allow(generator).to receive(:forest).and_return("Las #{root}", "Puszcza #{other_root} Cierni")

      expect(generator.unique.forest).to eq("Puszcza #{other_root} Cierni")
    end

    it 'does not treat a new prefix or suffix as a new proper name within the same category' do
      generator.unique.forest
      allow(generator).to receive(:forest).and_return("Puszcza #{root} Czarnych Cierni")

      expect { generator.unique.forest }.to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
    end

    it 'shares its proper-name history with the general-purpose name generator' do
      stub_const('FantasyFaker::Location::CATEGORIES', [:forest])
      generator.unique.city

      expect { generator.unique.name }.to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
    end

    it 'preserves the shared history across locale changes' do
      FantasyFaker.use_locale(:en)
      generator.unique.city
      FantasyFaker.use_locale(:pl)

      expect { generator.unique.forest }.to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
    end

    it 'clears history for every category at once so proper names can be reused' do
      generator.unique.city
      generator.unique.clear

      expect(generator.unique.forest).to eq("Mroczny Las #{root}")
      expect { generator.unique.city }.to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
    end

    it 'leaves ordinary calls unchanged and does not reserve their names' do
      expect(generator.city).to eq(root)
      expect(generator.unique.forest).to eq("Mroczny Las #{root}")
      expect(generator.city).to eq(root)
    end

    it 'does not share its history or clearing with Character' do
      allow(FantasyFaker::Character).to receive(:male_name).and_return(root)
      FantasyFaker::Character.unique.male_name

      expect(generator.unique.city).to eq(root)
      generator.unique.clear
      expect { FantasyFaker::Character.unique.male_name }
        .to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
    end

    it 'reserves all 1000 proper names globally and raises when the pool is exhausted' do
      allow(generator).to receive(:city).and_return(*proper_names, proper_names.last)
      generated = Array.new(1000) { generator.unique.city }

      expect(generated.uniq.size).to eq(1000)
      expect(generated).to match_array(proper_names)
      expect { generator.unique.forest }.to raise_error(FantasyFaker::UniqueGenerator::RetryLimitExceeded)
    end

    it 'reports supported methods and rejects unknown methods' do
      expect(generator.unique).to respond_to(:city, :forest, :name)
      expect { generator.unique.unknown_generator }.to raise_error(NoMethodError)
    end
  end
end
