require 'briskly'
require 'briskly/element'
require 'briskly/indexer'

class Briskly::Store

  attr_reader :key

  def initialize(key)
    @key        = key
    @indexer    = Briskly::Indexer.new
  end

  def with(values)
    values.length > 1 ? bulk(values) : individual(values)
    return self
  end

  def search(keyword, options = {})
    @indexer.search(keyword, options[:limit])
  end

  private

  def bulk(items)
    items.each do |term|
      els = Array(term[:keyword]).map { |key| Briskly::Element.new(key, term[:data]) }
      Array(term[:keyword]).length > 1 ? @indexer.group_index(els) : @indexer.bulk_index(els)
    end
  end

  def individual(item)
    item.each do |term|
      els = Array(term[:keyword]).map{ |key| Briskly::Element.new(key, term[:data]) }
      Array(term[:keyword]).length > 1 ? @indexer.group_index(els) : @indexer.reindex(Briskly::Element.new(term[:keyword], term[:data]))
    end
  end

end