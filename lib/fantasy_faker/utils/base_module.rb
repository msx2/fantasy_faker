# frozen_string_literal: true

require 'yaml'
require_relative 'array_utils'

module FantasyFaker
  module BaseModule
    def const_missing(const_name)
      fetch_data(const_name)
    end

    def fetch_data(key)
      normalized_key = underscore(key.to_s)
      current_locale = FantasyFaker.locale
      locale_data(current_locale)[normalized_key] || common_data[normalized_key] ||
        raise(KeyError, "Unknown data key: #{normalized_key}")
    end

    def locale_data(locale = FantasyFaker.locale)
      @locale_data ||= {}
      @locale_data[locale] ||= load_yaml_arrays(locale_data_path(locale))
    end

    def common_data
      @common_data ||= begin
        raw = YAML.safe_load_file(common_data_path) || {}
        section = raw[underscore(module_name)] || raw
        section.transform_values { |values| FantasyFaker::ArrayUtils.const_array(values) }
      end
    end

    def locale_data_path(locale)
      "#{FantasyFaker::ROOT_PATH}/locales/#{locale}/#{underscore(module_name)}.yml"
    end

    def common_data_path
      "#{FantasyFaker::ROOT_PATH}/locales/common.yml"
    end

    def load_yaml_arrays(path)
      return {} unless File.exist?(path)

      raw = YAML.safe_load_file(path) || {}
      raw.transform_values { |values| FantasyFaker::ArrayUtils.const_array(values) }
    end

    def module_name
      ancestors.first.to_s.split('::').last
    end

    def underscore(string)
      string.gsub('::', '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .tr('-', '_')
            .downcase
    end
  end
end
