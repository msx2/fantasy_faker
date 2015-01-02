module FantasyFaker
  module ArrayUtils
    def self.const_array(argument)
      array = argument.is_a?(Array) ? argument : argument.to_a
      array.extend ArrayUtils
      freeze_all(array)
    end

    def self.rand(array)
      array.shuffle.sample
    end

    def self.freeze_all(array)
      array.each { |e| e.freeze }
      array.freeze
      array
    end

    def rand
      ArrayUtils.rand(self)
    end

    def freeze_all
      ArrayUtils.freeze_all(self)
    end
  end
end
