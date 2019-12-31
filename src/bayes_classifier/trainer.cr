require "./bulk_processor.cr"

module BayesClassifier
  class Trainer < BulkProcessor
    getter data

    def initialize(@tokenizer : Tokenizer)
      @data = TrainedData.new
    end

    # enhances trained data using the given text and class
    def train(text : String, category_name : String) : Array(String)
      @data.increase_category(category_name)

      tokens = @tokenizer.tokenize(text)
      process_all(tokens) do |token|
        @data.increase_token(token, category_name)
      end
      tokens
    end

    def train_many(text_category_pairs : Array(Array(String))) : Array(Array(String))
      process_all(text_category_pairs) do | pair |
        train(pair[0], pair[1])
      end
    end
  end
end
