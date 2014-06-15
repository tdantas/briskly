require 'spec_helper'
require 'briskly/engine/trie'

describe Briskly::TrieEngine do

  describe '#fetch' do
    subject { described_class.new }

    it 'fetchs a previous indexed key' do
      subject.index('foo', 'value')
      expect(subject.fetch('foo')).to eql(['value'])
    end

    it 'returns nil when key does not exist' do
      expect(subject.fetch('none')).to eql(nil)
    end

  end

end
