module BayesClassifier
  class TrainedData
    getter doc_count_of_categories, frequencies

    def initialize
      @doc_count_of_categories = Hash(String, Int32).new
      @frequencies = Hash(String, Hash(String, Int32)).new
    end

    def increase_category(category_name : String, byAmount : Int = 1)
      @doc_count_of_categories[category_name] = \
        @doc_count_of_categories.fetch(category_name, 0) + 1
    end

    def increase_token(token : String,
                       category_name : String,
                       byAmount : Int = 1) : Int32
      if !@frequencies.keys.any? { |key| key == token }
        @frequencies[token] = {} of String => Int32
      end

      new_value =  @frequencies[token].fetch(category_name, 0) + 1
      @frequencies[token][category_name] = new_value
      new_value
    end

    # returns all documents count
    def get_doc_count
      return @doc_count_of_categories.values.sum
    end

    # returns the names of the available categories as list
    def get_categories : Array(String)
      return @doc_count_of_categories.keys
    end

    # returns document count of the category.
    # If category is not available, it returns Nil
    def get_category_doc_count(category_name : String) : Int32
      return @doc_count_of_categories.fetch(category_name, 0)
    end

    def get_frequency(token : String, category_name : String) : Int32
      found_token = @frequencies[token]?

      if found_token.nil?
        return 0
      else
        frequency = found_token[category_name]?
        return frequency || 0
      end
    end
  end
end
