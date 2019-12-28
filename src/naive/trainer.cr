module Naive
  class Trainer
    getter data

    def initialize(@tokeniser : Tokeniser)
      @data = TrainedData.new
    end

    # enhances trained data using the given text and class
    def train(text : String, class_name : String) : Array of String
      @data.increase_class(class_name)

      tokens = @tokeniser.tokenise(text)
      process_all(tokens) do |token|
        @data.increase_token(token, class_name)
      end
    end
  end
end
