module Search::Stemmer
  extend self

  STEMMER = Mittens::Stemmer.new

  def stem(value)
    if value.present?
      tokenize(value).join(" ")
    else
      value
    end
  end

  private
    def tokenize(value)
      tokens = []
      current_word = +""
      current_cjk = +""

      value.each_char do |char|
        if cjk_character?(char)
          if current_word.present?
            tokens << stem_word(current_word)
            current_word = +""
          end
          current_cjk << char
        elsif char =~ /[\p{L}\p{N}_]/
          if current_cjk.present?
            tokens << current_cjk
            current_cjk = +""
          end
          current_word << char
        else
          if current_word.present?
            tokens << stem_word(current_word)
            current_word = +""
          end
          if current_cjk.present?
            tokens << current_cjk
            current_cjk = +""
          end
        end
      end

      tokens << stem_word(current_word) if current_word.present?
      tokens << current_cjk if current_cjk.present?
      tokens
    end

    def cjk_character?(char)
      char.match?(Search::CJK_PATTERN)
    end

    def stem_word(word)
      STEMMER.stem(word.downcase)
    end
end
