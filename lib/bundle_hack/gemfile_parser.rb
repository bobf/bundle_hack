# frozen_string_literal: true

module BundleHack
  class GemfileParser
    def initialize(gemfile)
      @gemfile = gemfile
    end

    def line_numbers_for(gem_name)
      locations(by_name(gem_name))
    end

    private

    def by_name(gem_name)
      sexps = gems.select { |gem| gem.children[2].to_sexp_array[1] == gem_name }
      parsing_error(gem_name) if sexps.empty?

      sexps
    end

    def gems
      top_level_gems + group_gems
    end

    def top_level_gems
      gem_sexps_from_children(parsed_gemfile.children)
    end

    def group_gems
      parsed_gemfile.children.map do |child|
        next unless group?(child)

        gem_sexps_from_children(child.children[2..-1])
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

    def locations(sexps)
      sexps.map { |sexp| sexp.location.line }
    end

    def parsing_error(gem_name)
      raise ParsingError, I18n.t('errors.parsing', gem: gem_name)
    end
  end
end
