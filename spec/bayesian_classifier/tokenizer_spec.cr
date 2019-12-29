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
    sentence="These are some words!"
    tokenizer = BayesianClassifier::Tokenizer.new()
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("words").should be_true
  end
  it "should downcase everything" do
    sentence="These are Some words!"
    tokenizer = BayesianClassifier::Tokenizer.new()
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("these").should be_true
    tokens.includes?("some").should be_true
  end
  it "should not reorder tokens" do
    sentence="These are Some words!"
    tokenizer = BayesianClassifier::Tokenizer.new()
    tokens = tokenizer.tokenize(sentence)
    tokens.first.should(eq("these"))
    tokens.last.should(eq("words"))
  end
  it "should eliminate stop words" do
    sentence="These are facist some dictator words!"
    tokenizer = BayesianClassifier::Tokenizer.new(["dictator", "facist"])
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("facist").should be_false
    tokens.includes?("dictator").should be_false
    tokens.size.should(eq(4))
  end
end

