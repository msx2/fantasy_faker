# frozen_string_literal: true

module FantasyFaker
  module Location
    extend BaseModule
    extend self

    CATEGORIES = %i[
      city sewer meadow forest swamp waters desert cave mine mountain volcanic_field
      ruins stronghold graveyard abandoned_monastery labyrinth_or_arena
    ].freeze

    CATEGORIES.each do |category|
      define_method(category) { fetch_data(category).rand % { name: fetch_data(:proper_names).rand } }
    end

    def unique
      @unique_generator ||= begin
        proper_name = /\b#{Regexp.union(fetch_data(:proper_names))}\b/
        UniqueGenerator.new(self) { |name| name[proper_name] }
      end
    end

    def name
      public_send(CATEGORIES.sample)
    end
  end
end
