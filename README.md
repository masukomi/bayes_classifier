WARNING: I'm in the middle of a major refactoring. The API should be stable but I make no guarantees for the next few days ;) (Dec 29, 2019)

# Bayes Classifier

Naïve [Bayesian Classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier) for Crystal

> In machine learning, naïve Bayes classifiers are a family of simple "probabilistic classifiers" based on applying Bayes' theorem with strong (naïve) independence assumptions between the features. They are among the simplest Bayesian network models. - [Wikipedia](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)

At a high level, usage is very simple. First you "train" your classifier by providing a piece of text and telling it what "category" it belongs to. The more training data you have, the better your results would be. Then, after training you pass it a new piece of text, and it provides you a number between zero and one indicating how probable it is that the text belongs to the given category. The higher the number the more probable it is that it belongs to the specified category. 

Deciding what probability is "enough" depends a lot on what you're using it for. If someone may go to jail based on your probability score the threshold should be _very_ high. If you're just determining if an article is "interesting" to a user then a much lower probability would not only be acceptable, but preferred. 


This particular implementation leverage's Crystal's concurrency to efficiently process large amounts of text quickly, but it _does not_ included a mechanism for persisting the results of training. If you don't add that you'll need to re-train it every time you run it. 

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  gsl:
    github: masukomi/bayes_classifier
```


## Usage


```crystal
require "bayes_classifier"

tokeniser = BayesClassifier::Tokeniser.new

trainer = BayesClassifier::Trainer.new(tokeniser)

news_set = [
  {"text" => "not to eat too much is not enough to lose weight", "category" => "health"},
  {"text" => "Russia try to invade Ukraine", "category" => "politics"},
  {"text" => "do not neglect exercise", "category" => "health"},
  {"text" => "Syria is the main issue, Obama says", "category" => "politics"},
  {"text" => "eat to lose weight", "category" => "health"},
  {"text" => "you should not eat much", "category" => "health"},
]

news_set.each { |news|
  trainer.train(news["text"], news["category"])
}

classifier = BayesClassifier::Classifier.new(trainer.data, tokenizer)

classification = classifier.classify("Obama is")

puts classification # => {"health" => 1.6666666666666666e-10, "politics" => 0.083333333333333329}
```

If you only care about the probability of one, or some, categories in the training data, you can expedite the classification of a piece of text by specifying the list of categories to consider.

```
classification = classifier.classify("Obama is", ["health"])
#=> {"health" => 1.6666666666666666e-10}
```

## Tokenizer Notes
If you wish to eliminate certain words from your categorization, and/or process non-English languages, you will need to pass different arguments to the Tokenizer. It's initializer allows you to specify [stop words](https://en.wikipedia.org/wiki/Stop_words) (words to remove from consideration), junk characters (punctuation that isn't part of spelling), and depending on language, you may need to specify a different regexp to split words on. 

Note that junk characters are currently removed _after_ splitting the string, and the default regular expression limits them to the end of the string. This has 2 consequences:

First, removal _after_ splitting means that So if you added hyphen as a junk character (and removed the `$` at the end) the sentence "A full-length portrait" would be tokenized as ["a", "full length", "portrait"].

Second, the `$` at the end of the regexp means that, by default junk characters will only be removed from the end ofa word. So, `"the end!!!"` becomes `["the", "end"]` and `"v1.0.1"` stays `"v1.0.1"`

The Tokenizer's Initializer
```ruby
    def initialize(@stop_words      : Array(String) = [""],
                   @junk_characters : Regex = /[:\?!#%&3.\[\]\/+]+$/,
                   @split_regexp    : Regex = /\s+/)
    end
```

There is a default set of English stop words encoded as the `ENGLISH_STOP_WORDS` constant. To classify English text you'd probably want to initialize your tokenizer like this:

```ruby
tokenizer=BayesClassifier::Tokenizer.new(
  BayesClassifier::Tokenizer::ENGLISH_STOP_WORDS
)
```

If you wanted to tokenize some markdown but handle the links and images correctly you might initialize the tokenizer like this:

```
    tokenizer = BayesClassifier::Tokenizer.new(
                                            [""],
                                            /[:\?!#%&3.\[\]\/+()]+$/,
                                            /\s+|\[|\]\(|!|<|>/ 
                                            )
```

That will extract the image and url out of this: `![image](url)` 
and the link text and url out of this `[link text](url)` and
the url out of `<https://example.com>` that while throwing away
all the square brackets, angle brackets, and exclamation points.

Because parsing markdown is a fairly common thing these days, the tokenizer has a convenience method for this:

```
  tokenizer = BayesClassifier::Tokenizer.english_markdown_tokenizer
```

## Contributing

1. Fork it ( <https://github.com/masukomi/bayesian_classifier/fork> )
2. Create your feature branch (git checkout -b my-new-feature)
3. Add your code and a unit test.
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [masukomi](https://github.com/masukomi) masukomi - cleaner & maintainer
- [ruivieira](https://github.com/ruivieira) Rui Vieira - crystal port
- [muatik](https://github.com/muatik) muatik - original Python code
