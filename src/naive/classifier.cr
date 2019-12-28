module Naive
  class Classifier
    def initialize(@trainedData : TrainedData, @tokeniser : Tokeniser)
      @data = trainedData
      @defaultProb = 0.000000001
    end

    def getTokenProb(token : String, className : String) : Float64
      # p(token|Class_i)
      classDocumentCount = @data.getClassDocCount(className)
      # if the token is not seen in the training set, so not indexed,
      # then we return None not to include it into calculations.
      tokenFrequency = @data.getFrequency(token, className)
      if tokenFrequency.nil?
        return @defaultProb
      else
        probablity = tokenFrequency.to_f64 / classDocumentCount.as(Int32).to_f64
        return probablity
      end
    end

    def classify(text : String)
      documentCount = @data.getDocCount
      classes = @data.getClasses

      # only unique tokens
      tokens = @tokeniser.tokenise(text).uniq
      probsOfClasses = {} of String => Float64

      classes.each { |className|
        # we are calculating the probablity of seeing each token
        # in the text of this class
        # P(Token_1|Class_i)
        tokensProbs = tokens.map { |t| getTokenProb(t, className) }

        # calculating the probablity of seeing the the set of tokens
        # in the text of this class
        # P(Token_1|Class_i) * P(Token_2|Class_i) * ... * P(Token_n|Class_i)
        tokensSetProb = tokensProbs.reduce { |acc, p| acc * p }
        probsOfClasses[className] = tokensSetProb * getPrior(className)
      }
      return probsOfClasses
    end

    def getPrior(className : String)
      return @data.getClassDocCount(className).as(Int32).to_f64 / @data.getDocCount.to_f64
    end
  end
end
