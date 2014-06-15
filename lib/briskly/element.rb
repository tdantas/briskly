require 'briskly'
require 'briskly/keyword'

class Briskly::Element

  attr_reader :data
  attr_reader :keyword
  attr_reader :created_at

  attr_accessor :group

  def initialize(keyword, data = nil, created_at = Time.now.to_f)
    raise ArgumentError unless keyword

    @keyword      = Briskly::Keyword.new(keyword)
    @data         = data
    @created_at   = created_at
  end

  def keyword(internal = nil)
    internal == :internal ? @keyword : @keyword.to_s
  end

  def term
    @keyword.normalised
  end

end
