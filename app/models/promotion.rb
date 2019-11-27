# frozen_string_literal: true

require 'parser.rb'
require 'securerandom'
require_relative '../../lib/error/promotion_arguments_error.rb'
require_relative '../../lib/error/not_authorized_error.rb'
require_relative '../../lib/error/not_authenticated_error.rb'

class Promotion
  include ActiveModel::Model

  attr_accessor :id, :name, :code, :type, :return_type, :return_value, :condition ,:active, :promotion_type, :expiration

  def initialize(args = {})
    @id = args['id']
    @name = args['name']
    @code = args['code']
    @type = args['type']
    @return_type = args['return_type']
    @return_value = args['return_value']
    @condition = args['condition']
    @active = args['active']
    @promotion_type = args['promotion_type']
    @expiration =  to_simple_date args['expiration']
    @new = args['new'].nil? || args['new']
  end

  def to_simple_date(date)
    return nil unless date
    t = DateTime.parse(date)
    t.strftime("%m/%d/%Y")
  end

  def percentage?
    @return_type == 'percentage'
  end

  def persisted?
    return !@new
  end

end
