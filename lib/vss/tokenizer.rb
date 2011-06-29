require "stemmer"
require "active_support/core_ext"

module VSS
  class Tokenizer
    STOP_WORDS = %w[
      a b c d e f g h i j k l m n o p q r s t u v w x y z
      an and are as at be by for from has he in is it its
      of on that the to was were will with upon without among
    ]
  
    def self.tokenize(string)
      stripped = string.to_s.gsub(/[^a-z0-9\-\s\']/i, "") # remove punctuation
      words = stripped.split(/\s+/).reject(&:blank?).map(&:downcase).map(&:stem)
      words.reject { |word| STOP_WORDS.include?(word) }.uniq
    end
  end
end