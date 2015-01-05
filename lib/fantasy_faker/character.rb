# encoding: utf-8

module FantasyFaker

  module Character
    extend BaseModule
    extend self

    def male_first_name
      "%s%s" % [NAME_PREFIXES_MALE.rand, NAME_SUFIXES_MALE.rand]
    end

    def male_nickname
      NICKNAMES_MALE.rand
    end

    def male_name
      first_name = male_first_name

      ["#{first_name} #{male_nickname}", first_name].sample
    end

    def female_first_name
      "%s%s" % [NAME_PREFIXES_FEMALE.rand, NAME_SUFIXES_FEMALE.rand]
    end

    def female_nickname
      NICKNAMES_FEMALE.rand
    end

    def female_name
      first_name = female_first_name

      ["#{first_name} #{female_nickname}", first_name].sample
    end

  end

end
