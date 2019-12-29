module BayesClassifier
  class TrainedData
    getter doc_count_of_classes, frequencies

    def initialize
      @doc_count_of_classes = Hash(String, Int32).new
      @frequencies = Hash(String, Hash(String, Int32)).new
    end

    def increase_class(class_name : String, byAmount : Int = 1)
      @doc_count_of_classes[class_name] = @doc_count_of_classes.fetch(class_name, 0) + 1
    end

    def increase_token(token : String,
                       class_name : String,
                       byAmount : Int = 1)
      if !@frequencies.keys.any? { |key| key == token }
        @frequencies[token] = {} of String => Int32
      end

      @frequencies[token][class_name] = @frequencies[token].fetch(class_name, 0) + 1
    end

    # returns all documents count
    def get_doc_count
      return @doc_count_of_classes.values.sum
    end

    # returns the names of the available classes as list
    def get_classes
      return @doc_count_of_classes.keys
    end

    # returns document count of the class.
    # If class is not available, it returns Nil
    def get_class_doc_count(class_name : String)
      return @doc_count_of_classes.fetch(class_name, Nil)
    end

    def get_frequency(token : String, class_name : String) : Int32 | Nil
      found_token = @frequencies[token]?

      if found_token.nil?
        raise NotSeen.new
      else
        frequency = found_token[class_name]?
        return frequency
      end
    end
  end
end
