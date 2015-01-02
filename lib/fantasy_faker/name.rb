# encoding: utf-8

module FantasyFaker

  module Name
    extend BaseModule
    extend self

    def male_name
      "%s%s" % [NAME_PREFIXES_MALE.rand, NAME_SUFIXES_MALE.rand]
    end

  end

end
