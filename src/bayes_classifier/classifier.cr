require "./bulk_processor.cr"

module BayesClassifier
  class Classifier < BulkProcessor
    # Creates a new pre-trained Classifier
    # with a Tokenizer pre-configured for handling
    # the text that it will be asked to classify.
    #
    # Parameters:
    #
    # * trained_data: A TrainedData object
    # * tokenizer: A Tokenizer configured
    #   for the language and text that will be classified.
    def initialize(@trained_data : TrainedData,
                   @tokenizer : Tokenizer)
      @data = trained_data
      @defaultProb = 0.000000001
    end

    # Classifies a piece of text and returns a Hash whose
    # keys are the known categories, and whose values are the
    # probability that the text is a member of that category.
    #
    # Categories can be limited by specifying an array of
    # category names to limit comparisons to.
    def classify( text : String,
                  categories : Array(String) = @data.get_categories
                ) : Hash(String, Float64)
      document_count = @data.get_doc_count

      # only unique tokens
      tokens = @tokenizer.tokenize(text).uniq
      probabilities_of_categories = {} of String => Float64

      categories.each { |category_name|
        # we are calculating the probablity of seeing each token
        # in the text of this category
        # P(Token_1|Class_i)
        tokens_probabilities = process_all(tokens) do | t |
          get_token_probability(t, category_name)
        end

        # calculating the probablity of seeing the the set of tokens
        # in the text of this category
        # P(Token_1|Class_i) * P(Token_2|Class_i) * ... * P(Token_n|Class_i)
        tokens_set_probabilities = \
          tokens_probabilities.reduce { |acc, p| acc * p }
        probabilities_of_categories[category_name] = \
          tokens_set_probabilities * get_prior(category_name)
      }
      return probabilities_of_categories
    end

    private def get_prior(category_name : String)
      return @data\
        .get_category_doc_count(category_name)\
        .as(Int32)\
        .to_f64 / @data.get_doc_count.to_f64
    end
    private def get_token_probability(token : String,
                              category_name : String) : Float64
      # p(token|Class_i)
      category_document_count = @data.get_category_doc_count(category_name)
      # if the token is not seen in the training set, so not indexed,
      # then we return None not to include it into calculations.
      token_frequency = @data.get_frequency(token, category_name)
      if token_frequency == 0
        return @defaultProb
      else
        probablity = token_frequency.to_f64 / category_document_count.as(Int32).to_f64
        return probablity
      end
    end

  end
end
