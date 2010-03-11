require 'test/unit'
require 'vss'

class SearchTest < Test::Unit::TestCase
  def setup
    @doc1 = "I'm not even going to mention any TV series."
    @doc2 = "The Wire is the best thing ever. Fact."
    @doc3 = "Some would argue that Lost got a bit too wierd after season 2."
    @doc4 = "Lost is surely not in the same league as The Wire."
    @docs = [@doc1, @doc2, @doc3, @doc4]
    @engine = VSS::Engine.new(@docs)
  end
  
  def test_result_count
    results = @engine.search("How can you compare The Wire with Lost?")
    assert_equal 4, results.size
  end
  
  def test_ordering
    results = @engine.search("How can you compare The Wire with Lost?")
    assert_equal @doc4, results[0]
    assert_equal @doc2, results[1]
    assert_equal @doc3, results[2]
    assert_equal @doc1, results[3]
  end
  
  def test_ranking
    results = @engine.search("How can you compare The Wire with Lost?")
    assert_equal 68.2574185835055, results[0].rank
    assert_equal 58.5749292571254, results[1].rank
    assert_equal 55.5215763037423, results[2].rank
    assert_equal 50.0, results[3].rank
  end
end