# frozen_string_literal: true

module BundleHack
  class GemfileParser
    def initialize(gemfile)
      @gemfile = gemfile
    end

    def definitions_for(gem_name)
      definitions(by_name(gem_name))
    end

    private

    def by_name(gem_name)
      sexps = gems.select do |gem|
        gem[:sexp].children[2].to_sexp_array[1] == gem_name
      end

      parsing_error(gem_name) if sexps.empty?

      sexps
    end

    def gems
      top_level_gems + group_gems
    end

    def top_level_gems
      gem_sexps_from_children(parsed_gemfile.children).map do |sexp|
        { group: nil, sexp: sexp }
      end
    end

    def group_gems
      parsed_gemfile.children.map do |child|
        next unless group?(child)

        group = child.to_sexp_array[1].last.last
        gem_sexps_from_children(child.children[2..-1]).map do |sexp|
          { group: group, sexp: sexp }
        end
      end.compact.flatten(1)
    end

    def group?(sexp)
      sexp_array = sexp.to_sexp_array
      sexp_array[0] == :block && sexp_array[1][2] == :group
    end

    def gem_sexps_from_children(children)
      children.select do |child|
        sexp_array = child.to_sexp_array
        sexp_array[0] == :send && sexp_array[2] == :gem
      end
    end

    def parsed_gemfile
      @parsed_gemfile ||= begin
        @gemfile.rewind
        Parser::CurrentRuby.parse(@gemfile.read)
      end
    end

    def definitions(gems)
      gems.map do |gem|
        {
          group: gem[:group],
          locations: location(gem[:sexp]),
          params: hash_params(gem[:sexp])
        }
      end
    end

    def location(sexp)
      (sexp.location.first_line..sexp.location.last_line).to_a
    end

    def hash_params(sexp)
      last_arg_sexp = sexp.children.last
      return nil unless last_arg_sexp.to_sexp_array.first == :hash

      _, *pairs = last_arg_sexp.to_sexp_array

      Hash[key_value_pairs(pairs)]
    end

    def key_value_pairs(pairs)
      pairs.map do |_pair_sym, (_type, key), value|
        [key, nested_value(*value)]
      end
    end

    def nested_value(type, *values)
      return primitive(type) if values.empty?
      return array(values) if type == :array
      return hash(values) if type == :hash
      return values.first if %i[sym str].include?(type)

      raise ParsingError, I18n.t('errors.type', type: type)
    end

    def array(values)
      values.map { |type, value_array| nested_value(type, value_array) }
    end

    def hash(values)
      Hash[array(values)]
    end

    def primitive(type)
      # rubocop:disable Lint/BooleanSymbol
      case type
      when :false
        false
      when :true
        true
      when :nil
        nil
      end
      # rubocop:enable Lint/BooleanSymbol
    end

    def parsing_error(gem_name)
      raise ParsingError, I18n.t('errors.parsing', gem: gem_name)
    end
  end
end
