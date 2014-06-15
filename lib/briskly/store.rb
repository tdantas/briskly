require 'briskly'
require 'briskly/element'
require 'trie'
require 'securerandom'

class Briskly::Store

  attr_reader :key

  def initialize(key)
    @key      = key
    @store    = Trie.new
  end

  def with(values)
    values.length > 1 ? bulk(values) : individual(values)
    return self
  end

  def search(keyword, options = {})
    result    = fetch(keyword)
    limit     = options.fetch(:limit, result.length)
    result.first(limit)
  end

  private

  def add(element)
    @store.add(element.keyword(:internal).normalised, [element])
  end

  def append(element)
    keyword = element.keyword(:internal).normalised
    previous = @store.get(keyword) || []
    previous.push([element])
    @store.add(keyword, previous)
  end

  def bulk(items)
    items.each do |term|
      keywords = Array(term[:keyword])
      if keywords.length > 1
        related(keywords, term[:data])
      else
        keywords.each do |keyword|
          append(Briskly::Element.new(keyword, term[:data]))
        end
      end
    end
  end

  def extract_elements(children)
    children
      .map(&:last)
      .flatten
      .sort { |a,b| a.created_at <=> b.created_at }
      .uniq { |el| el.created_at}
  end

  def fetch(keyword)
    keyword   = Briskly::Keyword.new(keyword)
    children  = @store.children_with_values(keyword.normalised)
    extract_elements(children)
  end

  def individual(item)
    item.each do |term|
      if Array(term[:keyword]).length > 1
        related(term[:keyword], term[:data])
      else
        add(Briskly::Element.new(term[:keyword], term[:data]))
      end
    end
  end

  def related(keywords, data)
    created_at = Time.now.to_f
    Array(keywords).each do |keyword|
      add(Briskly::Element.new(keyword, data, created_at))
    end
  end

end