# frozen_string_literal: true

class ParsingError < StandardError
  def initialize(msg = 'Error while parsing')
    super
  end
end
