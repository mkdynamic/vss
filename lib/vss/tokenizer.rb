require 'stemmer'

module VSS
  class Tokenizer
    STOP_WORDS = %w[
      a b c d e f g h i j k l m n o p q r s t u v w x y z
      an and are as at be by for from has he in is it its
      of on that the to was were will with upon without among
    ].inject({}) { |h,v| h[v] = true; h }
  
    def self.tokenize(string)
      stripped = string.to_s.gsub(/[^a-z0-9\-\s\']/i, "") # removes punctuation
      words = stripped.split(/\s+/).reject { |word| word.match(/^\s*$/) }.map(&:downcase).map(&:stem)
      words.reject { |word| STOP_WORDS.key?(word) }.uniq
    end
  end
end
