module Naive
  class Tokeniser
    def initialize(@stop_words : Array(String) = [] of String, @signs : Array(String) = ["?!#%&"])
    end

    def tokenise(text : String)
      return text.downcase.split(" ")
    end

    def remove_stop_words(token : String)
      @stop_words.includes?(token) ? "stop_word" : token
    end

    def remove_punctuation(token : String)
      @signs.each { |sign|
        sign.each_char { |s| token = token.sub(s, "") }
      }
      return token
    end
  end
end
