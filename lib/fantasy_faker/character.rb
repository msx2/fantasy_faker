# encoding: utf-8

module FantasyFaker

  module Character
    extend BaseModule
    extend self

    def male_name
      "%s%s" % [NAME_PREFIXES_MALE.rand, NAME_SUFIXES_MALE.rand]
    end

    def male_nickname
      NICKNAMES_MALE.rand
    end

    def male_full_name
      "%s %s" % [male_name, male_nickname]
    end

    def female_name
      "%s%s" % [NAME_PREFIXES_FEMALE.rand, NAME_SUFIXES_FEMALE.rand]
    end

    def female_nickname
      NICKNAMES_FEMALE.rand
    end

    def female_full_name
      "%s %s" % [female_name, female_nickname]
    end

  end

end
