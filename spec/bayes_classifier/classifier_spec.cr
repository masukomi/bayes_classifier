require "../spec_helper"

describe BayesClassifier::Classifier do
  it "should initialize without error" do
    data = BayesClassifier::TrainedData.new()
    tokenizer = BayesClassifier::Tokenizer.new()
    c = BayesClassifier::Classifier.new(data, tokenizer)
    c.should be_truthy
  end


  it "should classify correctly" do
    tokenizer = BayesClassifier::Tokenizer.new()
    trainer = BayesClassifier::Trainer.new(tokenizer)
    news_set = [
      {"text" => "not to eat too much is not enough to lose weight", "category" => "health"},
      {"text" => "Russia try to invade Ukraine", "category" => "politics"},
      {"text" => "do not neglect exercise", "category" => "health"},
      {"text" => "Syria is the main issue, Obama says", "category" => "politics"},
      {"text" => "eat to lose weight", "category" => "health"},
      {"text" => "you should not eat much", "category" => "health"},
    ]

    news_set.each do  |news|
      trainer.train(news["text"], news["category"])
    end

    news_classifier = BayesClassifier::Classifier.new(
                                          trainer.data, tokenizer)

    classification = news_classifier.classify("Obama is")
    classification.keys.should(contain("health"))
    classification.keys.should(contain("politics"))
    classification.keys.size.should(eq(2))
  end
  it "should calculate probabilities" do
    tokenizer = BayesClassifier::Tokenizer.new()
    trainer = BayesClassifier::Trainer.new(tokenizer)
    news_set = [
      {"text" => "not to eat too much is not enough to lose weight", "category" => "health"},
      {"text" => "Russia try to invade Ukraine", "category" => "politics"},
      {"text" => "do not neglect exercise", "category" => "health"},
      {"text" => "Syria is the main issue, Obama says", "category" => "politics"},
      {"text" => "eat to lose weight", "category" => "health"},
      {"text" => "you should not eat much", "category" => "health"},
    ]

    news_set.each do  |news|
      trainer.train(news["text"], news["category"])
    end

    news_classifier = BayesClassifier::Classifier.new(
                                          trainer.data, tokenizer)

    classification = news_classifier.classify("Obama is")

    # testing floats sucks
    classification["health"].should be > 1.6e-10
    classification["health"].should be < 1.7e-10

    classification["politics"].should be > 0.083
    classification["politics"].should be <= 0.084
  end
  it "should be able to limit categories" do
    tokenizer = BayesClassifier::Tokenizer.new()
    trainer = BayesClassifier::Trainer.new(tokenizer)
    news_set = [
      {"text" => "not to eat too much is not enough to lose weight", "category" => "health"},
      {"text" => "Russia try to invade Ukraine", "category" => "politics"},
      {"text" => "do not neglect exercise", "category" => "health"},
      {"text" => "Syria is the main issue, Obama says", "category" => "politics"},
      {"text" => "eat to lose weight", "category" => "health"},
      {"text" => "you should not eat much", "category" => "health"},
    ]

    news_set.each do  |news|
      trainer.train(news["text"], news["category"])
    end

    news_classifier = BayesClassifier::Classifier.new(
                                          trainer.data, tokenizer)
    classification = news_classifier.classify("Obama is", ["health"])
    classification.keys.size.should(eq(1))
    classification.keys.first.should(eq("health"))
  end

end
