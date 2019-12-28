require "../spec_helper"

describe BayesianClassifier::Classifier do
  it "should initialize without error" do
    data = BayesianClassifier::TrainedData.new()
    tokenizer = BayesianClassifier::Tokenizer.new()
    c = BayesianClassifier::Classifier.new(data, tokenizer)
    c.should be_truthy
  end


  it "should classify correctly" do
    tokenizer = BayesianClassifier::Tokenizer.new()
    trainer = BayesianClassifier::Trainer.new(tokenizer)
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

    news_classifier = BayesianClassifier::Classifier.new(
                                          trainer.data, tokenizer)

    classification = news_classifier.classify("Obama is")
    classification.keys.should(contain("health"))
    classification.keys.should(contain("politics"))
    classification.keys.size.should(eq(2))
  end
  it "should calculate probabilities" do
    tokenizer = BayesianClassifier::Tokenizer.new()
    trainer = BayesianClassifier::Trainer.new(tokenizer)
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

    news_classifier = BayesianClassifier::Classifier.new(
                                          trainer.data, tokenizer)

    classification = news_classifier.classify("Obama is")

    # testing floats sucks
    classification["health"].should be > 1.6e-10
    classification["health"].should be < 1.7e-10

    classification["politics"].should be > 0.083
    classification["politics"].should be <= 0.084
  end

end
