require "./bulk_processor.cr"

module Naive
  class Tokenizer < BulkProcessor
    def initialize(@stop_words : Array(String) = [] of String,
                   @junk_characters : Regex = /[:\?!#%&3.\[\]\/+]/,
                   @split_regexp : Regex = /\w+/)
    end

    def tokenize(text : String) : Array of String
      (process_all(text.downcase.split(@split_regexp)) do |x|
        remove_junk_characters(x)
      end) - @stop_words
    end

    def remove_junk_characters(token : String) : String
      token.gsub(@junk_characters, "")
    end
  end
end
