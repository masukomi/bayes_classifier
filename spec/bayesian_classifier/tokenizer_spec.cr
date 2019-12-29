require "../spec_helper"

describe BayesianClassifier::Tokenizer do
  it "should split words on spaces" do
    tokenizer = BayesianClassifier::Tokenizer.new()
    sentence="These are some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.size.should(eq(4))
    tokens.uniq.size.should(eq(4))
  end
  it "should remove junk characters" do
    tokenizer = BayesianClassifier::Tokenizer.new()
    sentence="These are some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("words").should be_true
  end
  it "should downcase everything" do
    tokenizer = BayesianClassifier::Tokenizer.new()
    sentence="These are Some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("these").should be_true
    tokens.includes?("some").should be_true
  end
  it "should not reorder tokens" do
    tokenizer = BayesianClassifier::Tokenizer.new()
    sentence="These are Some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.first.should(eq("these"))
    tokens.last.should(eq("words"))
  end
  it "should eliminate stop words" do
    tokenizer = BayesianClassifier::Tokenizer.new(["dictator", "facist"])
    sentence="These are facist some dictator words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("facist").should be_false
    tokens.includes?("dictator").should be_false
    tokens.size.should(eq(4))
  end
  it "should have default english stop words" do
    tokenizer = BayesianClassifier::Tokenizer.new(
      BayesianClassifier::Tokenizer::ENGLISH_STOP_WORDS
    )
    sentence="These are some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.size.should(eq(1))
    tokens.first.should(eq("words"))
  end
end

