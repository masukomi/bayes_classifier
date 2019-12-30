require "../spec_helper"

describe BayesClassifier::Tokenizer do
  it "should split words on spaces" do
    tokenizer = BayesClassifier::Tokenizer.new()
    sentence="These are some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.size.should(eq(4))
    tokens.uniq.size.should(eq(4))
  end
  it "should remove junk characters" do
    tokenizer = BayesClassifier::Tokenizer.new()
    sentence="These are some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("words").should be_true
  end
  it "should remove multiple junk characters" do
    tokenizer = BayesClassifier::Tokenizer.new()
    sentence="These are some words!!!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("words").should be_true
  end

  it "should not remove junk in the middle of words" do
    tokenizer = BayesClassifier::Tokenizer.new()
    sentence="new release of v1.0.0 is awesome!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("v1.0.0").should be_true
  end
  it "should downcase everything" do
    tokenizer = BayesClassifier::Tokenizer.new()
    sentence="These are Some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("these").should be_true
    tokens.includes?("some").should be_true
  end
  it "should not reorder tokens" do
    tokenizer = BayesClassifier::Tokenizer.new()
    sentence="These are Some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.first.should(eq("these"))
    tokens.last.should(eq("words"))
  end
  it "should eliminate stop words" do
    tokenizer = BayesClassifier::Tokenizer.new(["dictator", "facist"])
    sentence="These are facist some dictator words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("facist").should be_false
    tokens.includes?("dictator").should be_false
    tokens.size.should(eq(4))
  end
  it "should have default english stop words" do
    tokenizer = BayesClassifier::Tokenizer.new(
      BayesClassifier::Tokenizer::ENGLISH_STOP_WORDS
    )
    sentence="These are some words!"
    tokens = tokenizer.tokenize(sentence)
    tokens.size.should(eq(1))
    tokens.first.should(eq("words"))
  end
  it "should allow complex splitting" do
    tokenizer = BayesClassifier::Tokenizer.new(
                                            [""],
                                            /[:\?!#%&3.\[\]\/+()]+$/,
                                            /\s+|\[|\]\(|!|<|>/ )
    sentence="This has [a link](https://example.com) in it and an ![image](https://example.com/foo.jpg) and a <https://example.com/other_link>!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("link").should(be_true)
    tokens.includes?("a").should(be_true)
    tokens.includes?("https://example.com").should(be_true)
    tokens.includes?("https://example.com/foo.jpg").should(be_true)
    tokens.includes?("image").should(be_true)
    tokens.includes?("https://example.com/other_link").should(be_true)

  end
  it "should provide a markdown tokenizer" do
    tokenizer = BayesClassifier::Tokenizer.markdown_tokenizer
    sentence="This has [a link](https://example.com) in it and an ![image](https://example.com/foo.jpg) and a <https://example.com/other_link>!"
    tokens = tokenizer.tokenize(sentence)
    tokens.includes?("link").should(be_true)
    tokens.includes?("a").should(be_true)
    tokens.includes?("https://example.com").should(be_true)
    tokens.includes?("https://example.com/foo.jpg").should(be_true)
    tokens.includes?("image").should(be_true)
    tokens.includes?("https://example.com/other_link").should(be_true)
  end
  it "should allow you to modify stop words" do
    tokenizer = BayesClassifier::Tokenizer.new()
    tokenizer.stop_words = [""]
    tokenizer.stop_words.first.should(eq(""))
    tokenizer.stop_words.size.should(eq(1))
  end
  it "should allow you to modify junk characters" do
    tokenizer = BayesClassifier::Tokenizer.new()
    tokenizer.junk_characters = /\s+/
    tokenizer.junk_characters.should(eq(/\s+/))
  end
  it "should allow you to modify split regexp" do
    tokenizer = BayesClassifier::Tokenizer.new()
    tokenizer.junk_characters = /\W+/
    tokenizer.junk_characters.should(eq(/\W+/))
  end
end

