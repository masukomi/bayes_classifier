require "../spec_helper"

describe BayesClassifier::Trainer do
  it "should train one thing" do
    tokenizer = BayesClassifier::Tokenizer.new()
    trainer = BayesClassifier::Trainer.new(tokenizer)
    sentence="These are some words!"
    trainer.train(sentence, "good")
    trainer.data.doc_count_of_categories["good"].should(eq(1))
    trainer.data.frequencies["these"]["good"].should(eq(1))
    trainer.data.frequencies["words"]["good"].should(eq(1))
  end
  it "should train many things" do
    tokenizer = BayesClassifier::Tokenizer.new()
    trainer = BayesClassifier::Trainer.new(tokenizer)
    data=[["These are some words!", "good"],
          ["these are words too", "good"]]
    trainer.train_many(data)
    trainer.data.doc_count_of_categories["good"].should(eq(2))
    trainer.data.frequencies["these"]["good"].should(eq(2))
    trainer.data.frequencies["too"]["good"].should(eq(1))
  end
end
