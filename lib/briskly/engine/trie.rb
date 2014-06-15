require 'trie'
require 'briskly/keyword'

class Briskly::TrieEngine

  def initialize
    @trie = Trie.new
  end

  def index(key, value)
    @trie.add(key, Array(value))
  end

  def reindex(old_element, new_element = nil)
    index(old_element.term, Array(old_element))
  end

  def search(raw_keyword, limit = nil)
    results = @trie.children_with_values(term(raw_keyword))
    elements = extract_elements(results)
    elements.first(limit || elements.length)
  end

  def indexed?(keyword)
    @trie.has_key(term(keyword))
  end

  def fetch(keyword)
    @trie.get(term(keyword))
  end

  private
  def term(raw_keyword)
    keyword = Briskly::Keyword.new(raw_keyword)
    keyword.normalised
  end

  def extract_elements(children)
    children
      .map(&:last)
      .flatten
      .sort { |a,b| a.created_at <=> b.created_at }
      .uniq { |el| el.group || Time.now.to_f }
  end

end