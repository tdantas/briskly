require 'spec_helper'
require 'briskly/element'

describe Briskly::Element do

  context 'one keyword' do

    let(:now) { Time.now.to_f }
    subject { described_class.new('foo', { a: 2 }, now) }

    describe '#new' do
      it 'accepts a keyword, data and created_at ' do
        expect(subject).to be_a described_class
      end

      it 'allows access to the keyword' do
        expect(subject.keyword).to eq('foo')
      end

      it 'allows access to the internal keyword instance' do
        expect(subject.keyword(:internal)).to be_a Briskly::Keyword
      end

      it 'allows access to its data' do
        expect(subject.data).to eql(a: 2)
      end

      it 'allows access to its creation date' do
        expect(subject.created_at).to eql(now)
      end
    end

  end

  context 'without keywords' do
    it 'raises ArgumentError' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
