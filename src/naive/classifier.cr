require "./bulk_processor.cr"

module Naive
  class Classifier < BulkProcessor
    def initialize(@trained_data : TrainedData,
                   @tokenizer : Tokenizer)
      @data = trained_data
      @defaultProb = 0.000000001
    end

    def get_token_probability(token : String, className : String) : Float64
      # p(token|Class_i)
      class_document_count = @data.get_class_doc_count(className)
      # if the token is not seen in the training set, so not indexed,
      # then we return None not to include it into calculations.
      token_frequency = @data.get_frequency(token, className)
      if token_frequency.nil?
        return @defaultProb
      else
        probablity = token_frequency.to_f64 / class_document_count.as(Int32).to_f64
        return probablity
      end
    end

    def classify(text : String)
      document_count = @data.get_doc_count
      classes = @data.get_classes

      # only unique tokens
      tokens = @tokenizer.tokenize(text).uniq
      probabilities_of_classes = {} of String => Float64

      classes.each { |className|
        # we are calculating the probablity of seeing each token
        # in the text of this class
        # P(Token_1|Class_i)
        tokens_probabilities = process_all(tokens) do | t |
          get_token_probability(t, className)
        end

        # calculating the probablity of seeing the the set of tokens
        # in the text of this class
        # P(Token_1|Class_i) * P(Token_2|Class_i) * ... * P(Token_n|Class_i)
        tokens_set_probabilities = tokens_probabilities.reduce { |acc, p| acc * p }
        probabilities_of_classes[className] = tokens_set_probabilities * get_prior(className)
      }
      return probabilities_of_classes
    end

    def get_prior(className : String)
      return @data\
        .get_class_doc_count(className)\
        .as(Int32)\
        .to_f64 / @data.get_doc_count.to_f64
    end
  end
end
