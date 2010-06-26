# VSS - Vector Space Search 

A simple vector space search engine with **tf*idf** ranking. 

[More info, and details of how it works.](http://madeofcode.com/posts/69-vss-a-vector-space-search-engine-in-ruby)

## Install

Just install the gem:

    gem install vss

## Usage

To perform a search on a collection of documents:

    require "vss"
    docs = ["hello", "goodbye", "hello and goodbye", "hello, hello!"]
    engine = VSS::Engine.new(docs)
    engine.search("hello") #=> ["hello", "hello, hello!", "hello and goodbye", "goodbye"]
    
## Rails/ActiveRecord

If you want to search a collection of `ActiveRecord` objects, you need to pass a **documentizer** `proc` when initializing `VSS::Engine` which will convert the objects into documents (which are simply strings). For example:

    class Page < ActiveRecord::Base
        #attrs: title, content
    end

    docs = Page.all
    documentizer = proc { |record| record.title + " " + record.content }
    engine = VSS::Engine.new(docs, documentizer)
        
## Notes

This isn't designed to be used on huge collections of records. The original use case was for ranking a smallish set of `ActiveRecord` results obtained via a query (using **SearchLogic**). So, essentially, the search consisted of 2 stages; getting the *corpus* via a SQL query, then doing the VSS on that.

## Credits

Heavily inspired by [Joesph Wilk's article on building a vector space search engine in Python](http://blog.josephwilk.net/projects/building-a-vector-space-search-engine-in-python.html).

Written by Mark Dodwell
([Design & Code](http://madeofcode.com))