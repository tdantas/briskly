require 'briskly'
require 'briskly/engine/trie'
require 'securerandom'

class Briskly::Indexer

  attr_reader :engine
  def initialize(engine = Briskly.index_engine)
    @engine = engine
  end

  def index(element)
    previous = @engine.fetch(element.term) || []
    previous.push(element)
    @engine.index(element.term, previous)
  end

  def reindex(old_element, new_element = nil)
    @engine.reindex(old_element, new_element)
  end

  def bulk_index(elements)
    Array(elements).each { |el| index(el) }
  end

  def group_index(elements)
    group_id = SecureRandom.hex(10)
    Array(elements).each { |el| el.group = group_id }
    bulk_index(elements)
  end

  def search(keyword, limit=nil)
    @engine.search(keyword, limit)
  end

  def indexed?(keyword)
    @engine.indexed?(keyword)
  end

  def fetch(keyword)
    @engine.fetch(keyword)
  end

end