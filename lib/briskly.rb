require 'briskly/version'

module Briskly
  @@storage = {}

  module_function

  def store(key)
    @@storage[key] = Briskly::Store.new(key)
  end

  def index_engine=(engine)
    @engine = engine
  end

  def index_engine
    @engine || (engine = Briskly::TrieEngine.new)
  end

  def on(*keys)
    stores = Array(keys).map { |key| @@storage[key] || Briskly::Store.new(key) }
    Briskly::Scope.new stores
  end

end

require 'briskly/store'
require 'briskly/scope'
require 'briskly/engine/trie'

