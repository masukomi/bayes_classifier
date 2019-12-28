module Naive
  class Trainer
    getter data

    def initialize(@tokeniser : Tokeniser)
      @data = TrainedData.new
    end

    # enhances trained data using the given text and class
    def train(text : String, className : String)
      @data.increaseClass(className)

      tokens = @tokeniser.tokenise(text)
      tokens.each { |token|
        token = @tokeniser.remove_stop_words(token)
        token = @tokeniser.remove_punctuation(token)
        @data.increaseToken(token, className)
      }
    end
  end
end
