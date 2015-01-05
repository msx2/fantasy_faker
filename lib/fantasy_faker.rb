module FantasyFaker
  VERSION = '0.0.3'

  require 'fantasy_faker/utils/array_utils'
  require 'fantasy_faker/utils/base_module'

  extend BaseModule

  BASE_LIB_PATH = File.expand_path('..', __FILE__)

  # Load all constants.
  Dir["#{BASE_LIB_PATH}/fantasy_faker/*.rb"].sort.each do |filename|
    require "fantasy_faker/#{File.basename(filename, '.rb')}"
  end
end
