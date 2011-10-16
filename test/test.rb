require 'bundler/setup'
require 'test/unit'
require 'vss'

class VSSTest < Test::Unit::TestCase
  def setup
    @doc1 = "I'm not even going to mention any TV series."
    @doc2 = "The Wire is the best thing ever. Fact."
    @doc3 = "Some would argue that Lost got a bit too wierd after season 2."
    @doc4 = "Lost is surely not in the same league as The Wire."
    @doc5 = "You cannot compare the The Wire and Lost."
    @docs = [@doc1, @doc2, @doc3, @doc4, @doc5]
    @engine = VSS::Engine.new(@docs)
  end
  
  def test_result_count
    results = @engine.search("How can you compare The Wire with Lost?")
    assert_equal 4, results.size
  end
  
  def test_ordering
    results = @engine.search("How can you compare The Wire with Lost?")
    assert_equal @doc5, results[0]
    assert_equal @doc4, results[1]
    assert_equal @doc2, results[2]
    assert_equal @doc3, results[3]
  end
  
  def test_ranking
    results = @engine.search("How can you compare The Wire with Lost?")
    assert_similar_float 82.1781, results[0].rank
    assert_similar_float 3.08166, results[1].rank
    assert_similar_float 1.37986, results[2].rank
    assert_similar_float 0.87530, results[3].rank
  end
  
  def test_no_match
    results = @engine.search("Zebra funnels cash")
    assert_equal 0, results.size
  end
  
private

  def assert_similar_float(expected, actual, msg = nil)
    assert Float === expected, "not a Float"
    sig_figs = [10, actual.to_s.size, expected.to_s.size].min - 1
    assert_equal expected.to_s[0, sig_figs], actual.to_s[0, sig_figs], msg
  end
end
