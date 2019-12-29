module BayesClassifier
  abstract class BulkProcessor
    def process_all(items : Indexable(T), &block : T -> R) forall T, R
      results = Array(R).new(items.size) { r = uninitialized R }
      done = Channel(Exception?).new

      items.each_with_index do |item, i|
        spawn do
          begin
            results[i] = block.call(item)
          rescue e
            done.send e
          else
            done.send nil
          end
        end
      end

      items.each do
        if (exc = done.receive)
          raise exc
        end
      end

      results
    end
  end
end
