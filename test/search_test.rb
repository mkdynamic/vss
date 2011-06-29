require 'test/unit'
require 'vss'

class SearchTest < Test::Unit::TestCase
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
    assert_equal 82.17814036133181, results[0].rank
    assert_equal 3.0816677568068283, results[1].rank
    assert_equal 1.3798683116522041, results[2].rank
    assert_equal 0.8753091481365445, results[3].rank
  end
end