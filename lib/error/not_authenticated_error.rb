# frozen_string_literal: true

class NotAuthenticatedError < StandardError
  def initialize(msg = 'Error while requesting info from promotion')
    super
  end
end
