# frozen_string_literal: true

module FantasyFaker
  module Character
    extend BaseModule
    extend self

    def male_first_name
      '%s%s' % [fetch_data(:name_prefixes_male).rand, fetch_data(:name_sufixes_male).rand]
    end

    def male_nickname
      fetch_data(:nicknames_male).rand
    end

    def male_name
      first_name = male_first_name

      ["#{first_name} #{male_nickname}", first_name].sample
    end

    def female_first_name
      '%s%s' % [fetch_data(:name_prefixes_female).rand, fetch_data(:name_sufixes_female).rand]
    end

    def female_nickname
      fetch_data(:nicknames_female).rand
    end

    def female_name
      first_name = female_first_name

      ["#{first_name} #{female_nickname}", first_name].sample
    end
  end
end
