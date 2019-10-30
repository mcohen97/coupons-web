# frozen_string_literal: true

class ServiceResponseError < StandardError
  def initialize(msg = "Couldn't get any response")
    super
  end
end