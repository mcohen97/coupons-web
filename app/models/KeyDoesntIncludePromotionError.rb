# frozen_string_literal: true

class KeyDoesntIncludePromotionError < StandardError
  def initialize(msg = 'Error while requesting info from promotion')
    super
  end
end
