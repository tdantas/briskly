require 'briskly/version' unless defined? Briskly::VERSION
require 'briskly/briskly'

module Briskly

  def self.collection(key: 'default')
    Collection.new(key)
  end

end

puts Briskly::Storage.store('foo', [1, 2]);
puts Briskly::Storage.get('foo');
