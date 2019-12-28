module Naive
  class TrainedData
    getter docCountOfClasses, frequencies

    def initialize
      @docCountOfClasses = Hash(String, Int32).new
      @frequencies = Hash(String, Hash(String, Int32)).new
    end

    def increaseClass(className : String, byAmount : Int = 1)
      @docCountOfClasses[className] = @docCountOfClasses.fetch(className, 0) + 1
    end

    def increaseToken(token : String, className : String, byAmount : Int = 1)
      if !@frequencies.keys.any? { |key| key == token }
        @frequencies[token] = {} of String => Int32
      end

      @frequencies[token][className] = @frequencies[token].fetch(className, 0) + 1
    end

    # returns all documents count
    def getDocCount
      return @docCountOfClasses.values.sum
    end

    # returns the names of the available classes as list
    def getClasses
      return @docCountOfClasses.keys
    end

    # returns document count of the class.
    # If class is not available, it returns Nil
    def getClassDocCount(className : String)
      return @docCountOfClasses.fetch(className, Nil)
    end

    def getFrequency(token : String, className : String) : Int32 | Nil
      foundToken = @frequencies[token]?

      if foundToken.nil?
        raise NotSeen.new
      else
        frequency = foundToken[className]?
        return frequency
      end
    end
  end
end
