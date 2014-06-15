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
    if values.length > 1
      bulk(values)
    else
      individual(values)
    end
    self
  end

  def search(keyword, options = {})
    keyword   = Briskly::Keyword.new(keyword)
    children  = @store.children_with_values(keyword.normalised)
    result    = extract_elements_from_children(children)
    limit     = options.fetch(:limit, result.length)
    result.first(limit)
  end

  private

   def add(element)
    keyword = element.keyword(:internal).normalised
    previous = @store.get(keyword)
    @store.add(keyword, [element])
  end

  def append(element)
    key = element.keyword(:internal).normalised
    previous = @store.get(key) || []
    previous.push([element])
    @store.add(key, previous)
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

  def extract_elements_from_children(children)
    children
      .map(&:last)
      .flatten
      .sort { |a,b| a.created_at <=> b.created_at }
      .uniq { |el| el.created_at}
  end

  def individual(item)
    item.each do |term|
      keywords = Array(term[:keyword])
      if keywords.length > 1
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

