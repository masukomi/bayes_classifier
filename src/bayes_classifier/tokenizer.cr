require "./bulk_processor.cr"

module BayesClassifier
  class Tokenizer < BulkProcessor
    ENGLISH_STOP_WORDS=%w(a able about across after all almost also am among an and any are as at be because been but by can cannot could dear did do does either else ever every for from get got had has have he her hers him his how however i if in into is it its just least let like likely may me might most must my neither no nor not of off often on only or other our own rather said say says she should since so some than that the their them then there these they this tis to too twas us wants was we were what when where which while who whom why will with would yet you your)
    def self.markdown_tokenizer : Tokenizer
      tokenizer = Tokenizer.new([""],
                                /[:\?!#%&3.\[\]\/+()]+$/,
                                /\s+|\[|\]\(|!|<|>/ )
    end

    def initialize(@stop_words      : Array(String) = [""],
                   @junk_characters : Regex = /[:\?!#%&3.\[\]\/+]+$/,
                   @split_regexp    : Regex = /\s+/)
    end

    def tokenize(text : String) : Array(String)
      (process_all(text.downcase.split(@split_regexp)) do |x|
        remove_junk_characters(x)
      end) - @stop_words
    end

    def remove_junk_characters(token : String) : String
      token.gsub(@junk_characters, "")
    end
  end
end
