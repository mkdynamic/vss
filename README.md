# VSS – Vector Space Search  &nbsp;[![Build Status](http://travis-ci.org/mkdynamic/vss.png?branch=master)](http://travis-ci.org/mkdynamic/vss)

A simple vector space search engine with tf*idf ranking. 

[More info, and details of how it works.](http://madeofcode.com/posts/69-vss-a-vector-space-search-engine-in-ruby)

## Installation

Just install the gem:

```bash
gem install vss
```

Or add to your Gemfile, if you're using Bundler:

```ruby
gem 'vss'
```

## Usage

To perform a search on a collection of documents:

```ruby
require "vss"
docs = ["hello", "goodbye", "hello and goodbye", "hello, hello!"]
engine = VSS::Engine.new(docs)
engine.search("hello") #=> ["hello", "hello, hello!", "hello and goodbye"]
```
    
## Rails/ActiveRecord

If you want to search a collection of `ActiveRecord` objects, you need to pass a **documentizer** `Proc` when initializing `VSS::Engine` which will convert the objects into documents (which are simply strings). For example:

```ruby
class Page < ActiveRecord::Base
    #attrs: title, content
end

docs = Page.all
documentizer = lambda { |record| record.title + " " + record.content }
engine = VSS::Engine.new(docs, documentizer)
```

## Notes

This isn't designed to be used on huge collections of records. The original use case was for ranking a smallish set of `ActiveRecord` results obtained via a query (using **SearchLogic**). So, essentially, the search consisted of 2 stages; getting the *corpus* via a SQL query, then doing the VSS on that.

## Ruby

Tested with the following Ruby versions:

- MRI 1.9.2
- MRI 1.8.7

Probably works on JRuby ~> 1.6 too, but not actively tested.

## Credits

Heavily inspired by [Joesph Wilk's article on building a vector space search engine in Python](http://blog.josephwilk.net/projects/building-a-vector-space-search-engine-in-python.html).

Written by Mark Dodwell ([@madeofcode](http://twitter.com/madeofcode))


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/mkdynamic/vss/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

