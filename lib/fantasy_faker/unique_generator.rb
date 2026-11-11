# frozen_string_literal: true

require 'set'

module FantasyFaker
  class UniqueGenerator
    class RetryLimitExceeded < RuntimeError; end

    def initialize(generator, &key)
      @generator = generator
      @key = key
      @previous_results = Hash.new { |results, method| results[method] = Set.new }
    end

    def clear
      @previous_results.clear
    end

    private

    def method_missing(method, ...)
      return super unless @generator.respond_to?(method)

      # Custom keys identify values across methods, not within one method.
      previous_results = @previous_results[@key ? nil : method]
      10_000.times do
        result = @generator.public_send(method, ...)
        key = @key ? @key.call(result) : result
        return result if previous_results.add?(key)
      end

      raise RetryLimitExceeded, "Unable to generate a unique #{method} after 10,000 attempts"
    end

    def respond_to_missing?(method, include_private = false)
      @generator.respond_to?(method) || super
    end
  end
end
