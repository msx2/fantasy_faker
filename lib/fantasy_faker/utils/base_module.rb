require 'fantasy_faker/utils/array_utils'

module FantasyFaker

  module BaseModule

    def const_missing(const_name)
      file_content = File.readlines(data_path(const_name)).map(&:strip)
      data         = FantasyFaker::ArrayUtils.const_array(file_content)

      const_set(const_name, data)
      data
    end

    def data_path(file_name)
      "#{FantasyFaker::BASE_LIB_PATH}/fantasy_faker/data/#{underscore(module_name)}/#{underscore(file_name.to_s)}"
    end

    def module_name
      ancestors.first.to_s.split('::').last
    end

    def underscore(string)
      string.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end

  end

end
