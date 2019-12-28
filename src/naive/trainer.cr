module Naive
  class Trainer
    getter data

    def initialize(@tokeniser : Tokeniser)
      @data = TrainedData.new
    end

    # enhances trained data using the given text and class
    def train(text : String, class_name : String)
      @data.increase_class(class_name)

      tokens = @tokeniser.tokenise(text)
      tokens.each { |token|
        token = @tokeniser.remove_stop_words(token)
        token = @tokeniser.remove_punctuation(token)
        @data.increase_token(token, class_name)
      }
    end
  end
end
