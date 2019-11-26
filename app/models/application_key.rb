# frozen_string_literal: true

class ApplicationKey
  include ActiveModel::Model

  attr_accessor :name, :token, :promotions

  def initialize(args = {})
    @name = args[:name]
    @token = args[:token]
    @promotions = args[:promotions]
    @new = args['new'].nil? || args['new']
  end

  def persisted?
    return !@new
  end
  
end
