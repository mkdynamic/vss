require "matrix"
require "vss/tokenizer"

module VSS
  class Engine    
    # `documentizer` just takes a record and converts it to a string
    def initialize(records, documentizer = proc { |document| document })
      @records = records    
      @documents = records.map { |record| documentizer.call(record) }
      @vocab = tokenize(@documents.join(" "))
    end

    def search(query)
      # get ranks
      query_vector = make_query_vector(query)
      ranks = @documents.map do |document|
        document_vector = make_vector(document)
        cosine_rank(query_vector, document_vector)
      end
    
      # now annotate records and return them
      @records.each_with_index do |record, i|
        # TODO: do this in a sensible way...
        record.instance_eval %{def rank; #{ranks[i]}; end}
      end
    
      # exclude 0 rank (no match) and sort by rank
      @records.reject { |r| r.rank == 0 }.sort { |a,b| b.rank <=> a.rank }
    end
  
    private
  
    # ranks from 0 to 100
    def cosine_rank(vector1, vector2)
      cosine(vector1, vector2) / 1 * 100
    end
  
    # see http://www.ltcconline.net/greenl/courses/107/vectors/DOTCROS.HTM
    # and http://ruby-doc.org/stdlib/libdoc/matrix/rdoc/index.html
    # will be in range 0 to 1, as vectors always positive
    def cosine(vector1, vector2)
      dot_product = vector1.inner_product(vector2)
      dot_product / (vector1.r * vector2.r) # Vector#r is same as ||v||
    end
  
    def make_query_vector(query)
      make_vector(query, true)
    end
  
    # NOTE: will choke if string contains tokens not in vocab
    #       this is why, when we make the query vector, we do an
    #       intersection of tokens with the vocab
    def make_vector(string, ensure_tokens_in_vocab = false)
      @vector_cache = {}
      @vector_cache[string] ||= begin
        arr = Array.new(vector_token_index.size, 0)
        
        tokens = tokenize(string)
        tokens &= @vocab if ensure_tokens_in_vocab
        tokens.uniq.each do |token| 
          index = vector_token_index[token]
          arr[index] = tf_idf(token, tokens, @documents)
        end
      
        Vector.elements(arr, false)
      end
    end
    
    def tf(token, tokens)
      count_in_array(tokens, token)
    end
    
    def idf(token, docs)
      docs_with_token_count = count_in_array(docs, proc { |doc| tokenize(doc).include?(token) })
      docs.size / docs_with_token_count     
    end
    
    # http://en.wikipedia.org/wiki/Tf-idf
    def tf_idf(token, tokens, docs)
      tf(token, tokens) * idf(token, @documents)
    end
  
    def vector_token_index
      @vector_token_index ||= begin
        index, offset = {}, 0      
      
        @vocab.each do |token|
          index[token] = offset
          offset += 1
        end
      
        index
      end
    end
  
    def tokenize(string)
      @tokenize_cache ||= {}
      @tokenize_cache[string] ||= Tokenizer.tokenize(string)
    end
  
    # could use Array#count, but only for Ruby 1.8.7 >=
    def count_in_array(array, item)
      count = 0
      if item.is_a? Proc
        array.each { |i| count += 1 if item.call(i) }
      else
        array.each { |i| count += 1 if i == item }
      end    
      count
    end
  end
end